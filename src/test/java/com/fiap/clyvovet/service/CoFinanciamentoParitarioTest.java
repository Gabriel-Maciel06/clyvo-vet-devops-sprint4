package com.fiap.clyvovet.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.math.RoundingMode;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Verifica a afirmação de co-financiamento paritário usada no material comercial:
 * "cada real de desconto é dividido meio a meio entre plataforma e clínica".
 *
 * <p>A conta relevante não é o campo {@code valorSubsidioClyvo} isolado, e sim o
 * <strong>sacrifício efetivo</strong> de cada lado: quanto cada um deixa de receber em
 * relação ao cenário sem desconto nenhum. É isso que uma clínica confere no extrato.</p>
 *
 * <pre>
 * Sem desconto:  clínica recebe (tabela - comissão)      plataforma recebe comissão
 * Com desconto:  clínica recebe repasse                  plataforma recebe comissão líquida
 * Sacrifício  =  diferença entre os dois cenários, para cada lado
 * </pre>
 */
class CoFinanciamentoParitarioTest {

    private final SplitFinanceiroCalculator calculadora = new SplitFinanceiroCalculator();

    private record Sacrificio(BigDecimal clinica, BigDecimal plataforma) {}

    private Sacrificio medir(BigDecimal tabela, int descontoPct) {
        SplitFinanceiroCalculator.Resultado r = calculadora.calcular(tabela, descontoPct);

        BigDecimal comissaoSemDesconto = tabela
                .multiply(SplitFinanceiroCalculator.TAXA_TAKE_RATE_PADRAO)
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        BigDecimal repasseSemDesconto = tabela.subtract(comissaoSemDesconto);

        BigDecimal sacrificioClinica = repasseSemDesconto.subtract(r.valorRepasseClinica());

        // A plataforma sacrifica a comissão que deixou de reter mais o que pagou do caixa.
        BigDecimal sacrificioPlataforma = comissaoSemDesconto
                .subtract(r.valorComissaoClyvo())
                .add(r.valorPrejuizoPlataforma());

        return new Sacrificio(sacrificioClinica, sacrificioPlataforma);
    }

    @Test
    @DisplayName("Nos quatro níveis vigentes, plataforma e clínica cedem exatamente o mesmo valor")
    void nosNiveisVigentesOCustoEhParitario() {
        int[] niveis = {5, 10, 15, 20}; // Bronze, Prata, Ouro, Diamante
        BigDecimal[] tabelas = {
                new BigDecimal("140.00"), new BigDecimal("150.00"),
                new BigDecimal("180.00"), new BigDecimal("290.00")
        };

        for (BigDecimal tabela : tabelas) {
            for (int desconto : niveis) {
                Sacrificio s = medir(tabela, desconto);

                assertEquals(0, s.clinica().compareTo(s.plataforma()),
                        () -> "Tabela R$ " + tabela + " com " + desconto + "% deveria ser 50/50, "
                                + "mas clínica cedeu R$ " + s.clinica()
                                + " e plataforma cedeu R$ " + s.plataforma());

                BigDecimal descontoTotal = tabela.multiply(BigDecimal.valueOf(desconto))
                        .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
                assertEquals(0, descontoTotal.compareTo(s.clinica().add(s.plataforma())),
                        "A soma dos dois sacrifícios tem de fechar o desconto concedido");
            }
        }
    }

    @Test
    @DisplayName("Acima de 20% a paridade deixa de valer: a plataforma passa a ceder mais")
    void acimaDoTetoAParidadeSeRompe() {
        // Documenta a fronteira da afirmação. Não existe nível acima de 20% hoje, mas se
        // algum for criado, o material comercial precisará deixar de dizer "meio a meio".
        Sacrificio s = medir(new BigDecimal("100.00"), 30);

        assertTrue(s.plataforma().compareTo(s.clinica()) > 0,
                "Passando do teto, o piso de 75% joga o excedente todo na plataforma");
    }

    @Test
    @DisplayName("O teto de 20% coincide exatamente com o limite do piso de 75%")
    void tetoDeDescontoCoincideComOLimiteDoPiso() {
        SplitFinanceiroCalculator.Resultado r =
                calculadora.calcular(new BigDecimal("150.00"), 20);

        assertFalse(r.pisoProtegidoAplicado(),
                "No teto vigente o piso ainda não precisa ser acionado");
        assertEquals(0, new BigDecimal("112.50").compareTo(r.valorRepasseClinica()),
                "A clínica recebe exatamente 75% da tabela, o piso na mosca");
        assertEquals(0, BigDecimal.ZERO.compareTo(r.valorPrejuizoPlataforma()),
                "E a plataforma ainda não paga nada do próprio caixa");
    }
}
