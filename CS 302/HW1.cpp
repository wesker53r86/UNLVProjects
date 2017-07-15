#include <iostream>

using namespace std;

int QuesA (int);
int QuesB (int);
int QuesC (int);
int QuesD (int);
int QuesE (int);
int QuesF (int);

int main()
{
	int n;
	int counter;

	cout << "please enter a value for n" << endl;
	cin >> n;

	counter = QuesA(n);
	cout << "Question A: " << counter << endl;

	counter = QuesB(n);
	cout << "Question B: " << counter << endl;

	counter = QuesC(n);
	cout << "Question C: " << counter << endl;

	counter = QuesD(n);
	cout << "Question D: " << counter << endl;

	counter = QuesE(n);
	cout << "Question E: " << counter << endl;

	counter = QuesF(n);
	cout << "Question F: " << counter << endl;


return 0;

}



int QuesA (int n)
{
	int counter=0;

	for (int i=0;i<n;i++)
	{
		counter++;
	}


return counter;
}

int QuesB (int n)
{
	int counter=0;

	for (int i=0;i<n;i++)
	{
		counter++;
		for (int j=0;j<n;j++)
		{
			counter++;
		}
	}

return counter;
}

int QuesC (int n)
{
	int counter=0;

	for (int i=0;i<n;i++)
	{
		counter++;
		for(int j=0;j<n*n;j++)
		{
			counter++;
		}
	}

return counter++;
}

int QuesD (int n)
{
	int counter=0;

	for (int i=0;i<n;i++)
	{
		counter++;
		for (int j=0;j<i;j++)
		{
			counter++;
		}
	}
return counter;
}


int QuesE (int n)
{
	int counter=0;

	for(int i=0;i<n;i++)
	{
		counter++;
		for(int j=0;j<i*i;j++)
		{
			counter++;
			for(int k=0;k<j;k++)
			{
				counter++;
			}
		}
	}


return counter;
}

int QuesF (int n)
{
	int counter=0;

	for(int i=1;i<n;i++)
	{
		counter++;
		for(int j=1;j<i*i;j++)
		{
			counter++;
			if(j%1==0)
			{
				for(int k=0; k<j;k++)
				{
					counter++;
				}
			}

		}
	}

return counter;
}
