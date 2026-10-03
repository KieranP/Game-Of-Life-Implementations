declare var process: {
  env: {
    MINIMAL: string;
  };
  stdout: {
    write(data: string): void;
  };
};
