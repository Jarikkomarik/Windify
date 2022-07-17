class CalculationResult {
  CalculationResult(String awgWindSpeed, String yearlyKwh){
    this.awgWindSpeed = awgWindSpeed;
    this.yearlyKwh = yearlyKwh;
    this.awgYearlyIncome = (double.parse(yearlyKwh) * 5).toString();
  }

  String awgWindSpeed = "";
  String yearlyKwh = "";
  String awgYearlyIncome = "";

  @override
  String toString() {
    return 'CalculationResult{awgWindSpeed: $awgWindSpeed, yearlyKwh: $yearlyKwh, awgYearlyIncome: $awgYearlyIncome}';
  }
}