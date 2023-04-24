enum EnviromentType {
  real,
  simulated;

  bool get isReal => this == EnviromentType.real;
  bool get isSimulated => this == EnviromentType.simulated;
}
