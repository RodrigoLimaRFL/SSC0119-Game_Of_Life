// Function to print the grid
void printGrid(int grid[30][30])
{
    for (int i = 0; i < 30; i++)
    {
        for (int j = 0; j < 30; j++)
        {
            if (grid[i][j] == 0)
                printf(".");
            else
                printf("O");
        }
        printf("\n");
    }
}


int wrapNumber(int x)
{
    if (x >= 0)
        return x % 30;
    else
        return (x + 30) % 30;
}


// Function to check if cell is valid
int isValid(int x, int y)
{
    return (x >= 0 && x < 30 && y >= 0 && y < 30);
}

// Function to count the number of live cells around cell
int countLiveCells(int grid[30][30], int x, int y)
{
    int count = 0;
    int dx[] = {1, 1, 0, -1, -1, -1, 0, 1};
    int dy[] = {0, 1, 1, 1, 0, -1, -1, -1};

    for (int i = 0; i < 8; i++)
    {
        if (grid[wrapNumber(x + dx[i])][wrapNumber(y + dy[i])] == 1)
            count++;
    }

    return count;
}

// Function to update the grid
void updateGrid(int grid[30][30])
{
    int newGrid[30][30];

    for (int i = 0; i < 30; i++)
    {
        for (int j = 0; j < 30; j++)
        {
            int liveCells = countLiveCells(grid, i, j);

            if (grid[i][j] == 1)
            {
                if (liveCells < 2)
                    newGrid[i][j] = 0;
                else if (liveCells == 2 || liveCells == 3)
                    newGrid[i][j] = 1;
                else
                    newGrid[i][j] = 0;
            }
            else
            {
                if (liveCells == 3)
                    newGrid[i][j] = 1;
                else
                    newGrid[i][j] = 0;
            }
        }
    }

    for (int i = 0; i < 30; i++)
    {
        for (int j = 0; j < 30; j++)
        {
            grid[i][j] = newGrid[i][j];
        }
    }
}

void initGrid(int grid[30][30])
{
    for (int i = 0; i < 30; i++)
    {
        for (int j = 0; j < 30; j++)
        {
            grid[i][j] = 0;
        }
    }

    grid[1][29] = 1;
    grid[2][29] = 1;
    grid[3][29] = 1;
    grid[3][28] = 1;
    grid[2][27] = 1;
}

int main()
{
    int grid[30][30];

    initGrid(grid);

    for (int i = 0; i < 5; i++)
    {
        printGrid(grid);
        updateGrid(grid);
        printf("\n");
    }

    return 0;
}