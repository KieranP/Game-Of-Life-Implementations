declare class Deno {
  static env: {
    get(a: string): string;
  };
}

declare var process: {
  env: {
    MINIMAL: string;
  };
};
