// import 'package:sudoku_solver/sudoku_solver.dart' as sudoku_solver;

// void main(List<String> arguments) {
//   print('Hello world: ${sudoku_solver.calculate()}!');
// }


// Функція для вирішення судоку
bool solveSudoku(List<List<int>> grid) {
  // Пошук порожньої клітинки
  List<int> emptyCell = findEmptyCell(grid);
  int row = emptyCell[0];
  int col = emptyCell[1];

  // Базовий випадок - якщо не залишилось порожніх клітинок
  if (row == -1 && col == -1) {
    return true; // Судоку вирішено
  }

  // Перебір цифр від 1 до 9
  for (int num = 1; num <= 9; num++) {
    // Перевірка чи цифра може бути поміщена у дану клітинку
    if (isValidMove(grid, row, col, num)) {
      grid[row][col] = num; // Заповнення клітинки знайденою цифрою

      // Рекурсивний виклик для наступної порожньої клітинки
      if (solveSudoku(grid)) {
        return true; // Судоку вирішено
      }

      grid[row][col] = 0; // Скидання клітинки, якщо розв'язок неможливий
    }
  }

  return false; // Немає розв'язку для судоку
}

// Функція для пошуку порожньої клітинки
List<int> findEmptyCell(List<List<int>> grid) {
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      if (grid[row][col] == 0) {
        return [row, col]; // Повертаємо рядок та стовпчик порожньої клітинки
      }
    }
  }
  return [-1, -1]; // Повертаємо [-1, -1], якщо не знайдено порожньої клітинки
}

// Функція для перевірки чи можна вставити цифру в дану клітинку
bool isValidMove(List<List<int>> grid, int row, int col, int num) {
  // Перевірка рядка
  for (int i = 0; i < 9; i++) {
    if (grid[row][i] == num) {
      return false; // Цифра вже присутня у рядку
    }
  }

  // Перевірка стовпчика
  for (int i = 0; i < 9; i++) {
    if (grid[i][col] == num) {
      return false; // Цифра вже присутня у стовпчику
    }
  }

  // Перевірка 3x3 підсітки
  int subgridStartRow = (row ~/ 3) * 3;
  int subgridStartCol = (col ~/ 3) * 3;
  for (int i = subgridStartRow; i < subgridStartRow + 3; i++) {
    for (int j = subgridStartCol; j < subgridStartCol + 3; j++) {
      if (grid[i][j] == num) {
        return false; // Цифра вже присутня у підсітці
      }
    }
  }

  return true; // Цифра може бути вставлена у дану клітинку
}

// Приклад використання
void main() {
  List<List<int>> grid = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9]
  ];

  if (solveSudoku(grid)) {
    print('Судоку вирішено:');
    printGrid(grid);
  } else {
    print('Судоку не має розв\'язку.');
  }
}

// Функція для виводу судоку на екран
void printGrid(List<List<int>> grid) {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      print('${grid[i][j]} ');
    }
    print('\n');
  }
}
