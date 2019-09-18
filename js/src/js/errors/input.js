class InputError extends Error {
  constructor(code, message) {
    const full = message ? `${ code }: ${ message }` : code;
    super(full);

    this.name = code;
    this.message = full;
  }
}

export default InputError;
