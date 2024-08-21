<template>
  <div class="container mt-5">
    <h1 class="text-center mb-4">Calculadora de Desconto de Parcelas</h1>
    <div class="form-group">
      <div class="row">
        <div class="col-md-4">
          <label for="valorTotal">Valor da Parcela (R$):</label>
          <input type="number" id="valorTotal" class="form-control text-center" v-model.number="valorParcela" step="0.01" min="0" maxlength="5cle">
        </div>
        <div class="col-md-4">
          <label for="parcelas">Total de parcelas restantes:</label>
          <input type="number" id="parcelas" class="form-control text-center" v-model.number="parcelas" min="1" maxlength="3">
        </div>
        <div class="col-md-4">
          <label for="taxaAnual">Taxa Anual de Desconto (%):</label>
          <input type="number" id="taxaAnual" class="form-control text-center" v-model.number="taxaAnual" step="0.01" min="0" maxlength="5">
        </div>
      </div>
    </div>
    <table class="table table-bordered table-hover mt-4" v-if="parcelasCalculadas.length > 0">
      <thead class="table-secondary">
        <tr>
          <th class="text-center">Número da Parcela</th>
          <th class="text-right">Parcela Original (R$)</th>
          <th class="text-right">Valor com Desconto (R$)</th>
          <th class="text-right">Valor do Desconto (R$)</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="parcela in parcelasCalculadas" :key="parcela.numeroParcela">
          <td class="text-center">{{ parcela.numeroParcela }}</td>
          <td class="text-right">{{ formatarNumero(parcela.valorOriginalAcumulado) }}</td>
          <td class="text-right">{{ formatarNumero(parcela.valorComDescontoAcumulado) }}</td>
          <td class="text-right">{{ formatarNumero(parcela.valorDesconto) }}</td>
        </tr>
      </tbody>
    </table>

    <footer class="mt-5 pt-4 pb-4 text-center bg-light border-top">
      <p>
        Repositório no <a href="https://github.com/andersonpereiradossantos/calculadora-antecipacao-parcelas" target="_blank">GitHub</a> |
        <a href="https://www.linkedin.com/in/andersonpereirasantos/" target="_blank"> LinkedIn</a>
      </p>
      <p>&copy; {{ anoCorrente }} Calculadora de Desconto de Parcelas</p>
      <button type="button" class="btn btn-primary mb-4" data-bs-toggle="modal" data-bs-target="#modalExplicacao">
        Como funciona o cálculo?
      </button>
    </footer>

    <!-- Modal -->
    <div class="modal fade" id="modalExplicacao" tabindex="-1" aria-labelledby="modalExplicacaoLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalExplicacaoLabel">Como funciona o cálculo?</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p class="text-left"><strong>1. Valor da Parcela:</strong> O valor de cada parcela a ser antecipada.</p>
            <p class="text-left"><strong>2. Parcelas Antecipadas:</strong> Número de parcelas que serão antecipadas. Isso determina o número de parcelas que serão aplicados os descontos.</p>
            <p class="text-left"><strong>3. Taxa Anual de Desconto:</strong> Taxa de desconto aplicada anualmente. A taxa é convertida em uma taxa mensal para calcular o valor presente das parcelas.</p>
            <p class="text-left"><strong>4. Cálculo do Valor Presente:</strong> Para cada parcela antecipada, calcula-se o valor presente usando a fórmula:</p>
            <p class="text-center"><code>Valor Presente = Valor da Parcela / (1 + Taxa Mensal) ^ Parcelas Restantes</code></p>
            <p class="text-left"><strong>5. Desconto da Parcela:</strong> A diferença entre o valor original da parcela e o valor presente é o valor do desconto para aquela parcela.</p>
            <p class="text-left">Os valores apresentados na tabela mostram o valor original acumulado das parcelas, o valor com desconto acumulado e o valor do desconto em cada parcela.</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      valorParcela: null,
      parcelas: null,
      taxaAnual: 10.58,
      anoCorrente: new Date().getFullYear()
    };
  },
  computed: {
    taxaMensal() {
      return Math.pow(1 + this.taxaAnual / 100, 1 / 12) - 1;
    },
    parcelasCalculadas() {
      const parcelas = [];
      let totalDesconto = 0;

      for (let i = 1; i <= this.parcelas; i++) {
        const parcelasRestantes = this.parcelas - i + 1;
        const valorOriginalAcumulado = this.valorParcela * i;
        const valorPresente = this.valorParcela / Math.pow(1 + this.taxaMensal, parcelasRestantes);
        const descontoParcela = this.valorParcela - valorPresente;
        totalDesconto += descontoParcela;

        const valorComDescontoAcumulado = valorOriginalAcumulado - totalDesconto;
        const percentualDesconto = (descontoParcela * 100) / valorOriginalAcumulado;

        parcelas.push({
          numeroParcela: i,
          valorOriginalAcumulado: valorOriginalAcumulado,
          valorComDescontoAcumulado: valorComDescontoAcumulado,
          valorDesconto: valorOriginalAcumulado - valorComDescontoAcumulado,
          percentualDesconto: percentualDesconto,
        });
      }

      return parcelas;
    },
    totalOriginal() {
      return this.valorParcela * this.parcelas;
    },
    totalComDesconto() {
      return this.parcelasCalculadas[this.parcelas - 1].valorComDescontoAcumulado;
    },
    totalDesconto() {
      return this.parcelasCalculadas.reduce((total, parcela) => total + parcela.valorDesconto, 0);
    },
  },
  methods: {
    formatarNumero(numero) {
      return numero.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    },
    formatarPercentual(numero) {
      return numero.toFixed(2) + '%';
    },
  },
};
</script>

<style scoped>
.table th, .table td {
  text-align: right;
}

.table th {
  background-color: #f8f9fa;
}

footer {
  background-color: #f8f9fa;
  color: #6c757d;
}

footer a {
  color: #007bff;
}

footer a:hover {
  text-decoration: underline;
}

.text-left {
  text-align: left;
}
</style>
