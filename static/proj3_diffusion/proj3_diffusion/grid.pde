class Grid {
  
  static final int maxNum = 100;
  float[][] U = new float[maxNum][maxNum];
  float[][] V = new float[maxNum][maxNum];
  float[][] tempU = new float[maxNum][maxNum];
  float[][] tempV = new float[maxNum][maxNum];
  float[][] grid = U;
  int n;
  
  static final float ru = 0.082, rv = 0.041;
  float k = 0.0625, f = 0.035;
  static final float delta_t = 1.0;
  static final float k1 = 0.03, k2 = 0.07, f1 = 0.0, f2 = 0.08;
  
  Grid(int n) {
    this.n = n;
  }
  
  void initialize() {
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        U[i][j] = 1;
        V[i][j] = 0;
      }
    }
    for (int i = n / 2 - 5; i < n / 2 + 5; ++i) {
      for (int j = n / 2 - 5; j < n / 2 + 5; ++j) {
        U[i][j] = 0.5;
        V[i][j] = 0.25;
      }
    }
  }
  
  float getK(int j) {
    return (k2 - k1) * j / n + k1;
  }
  float getF(int i) {
    return (f2 - f1) * i / n + f1;
  }
  
  private float diffusion(float[][] A, float rate, int i, int j) {
    float t = 0;
    if (i > 0) t += A[i - 1][j];
    if (j > 0) t += A[i][j - 1];
    if (i < n - 1) t += A[i + 1][j];
    if (j < n - 1) t += A[i][j + 1];
    t -= 4 * A[i][j];
    return rate * t;
  }
  void diffusion() {
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        tempU[i][j] = U[i][j] + diffusion(U, ru, i, j) * delta_t;
        tempV[i][j] = V[i][j] + diffusion(V, rv, i, j) * delta_t;
      }
    }
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        U[i][j] = tempU[i][j];
        V[i][j] = tempV[i][j];
      }
    }
  }
  

  void reaction() {
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        if (isSpatiallyVarying) {
          tempU[i][j] = U[i][j] + (-U[i][j] * sq(V[i][j]) + getF(j) * (1 - U[i][j])) * delta_t;
          tempV[i][j] = V[i][j] + (U[i][j] * sq(V[i][j]) - (getF(j) + getK(i)) * V[i][j]) * delta_t;
        }
        else {
          tempU[i][j] = U[i][j] + (-U[i][j] * sq(V[i][j]) + f * (1 - U[i][j])) * delta_t;
          tempV[i][j] = V[i][j] + (U[i][j] * sq(V[i][j]) - (f + k) * V[i][j]) * delta_t;
        }
      }
    }
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        U[i][j] = tempU[i][j];
        V[i][j] = tempV[i][j];
      }
    }
  }
  
  void update() {
    diffusion();
    if (isReactionDiffusion) reaction();
  }
  
  void drawGrid() {
    float w = 1.0 * width / n, h = 1.0 * height / n;
    float max_value = Float.MIN_VALUE, min_value = Float.MAX_VALUE;
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        max_value = max(max_value, grid[i][j]);
        min_value = min(min_value, grid[i][j]);
      }
    }
    float scale = 0;
    if (max_value - min_value == 0) scale = 1;
    else scale = 1.0 / (max_value - min_value);
    for (int i = 0; i < n; ++i) {
      for (int j = 0; j < n; ++j) {
        int value = (int)((grid[i][j] - min_value) * scale * 256);
        noStroke();
        fill(value, value, value);
        rect(w * j, h * i, w, h);
      }
    }
  }
  
  void printValues() {
    float w = 1.0 * width / n, h = 1.0 * height / n;
    int i = (int)(mouseX / w), j = (int)(mouseX / h);
    println("u: " + U[i][j] + " " + "v: " + V[i][j]);
  }
}