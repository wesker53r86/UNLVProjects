#include <iostream>
#include <fstream>


using namespace std;

void SecSort(double[], int);
void BubSort(double[], int);
void QukSort(double[], int);



int main()
{
	ifstream inFile;
	
	double Arrorig[1000];
	double Arrs[1000];
}



void SecSort(double Arrs[], int n)
{
	double temp;
	double min;
	int index;
	for(int i=0;i<n;i++)
	{
		min = Arrs[i];
		for(int j=i+1;j<n;j++)
		{
			if(min>Arrs[j])
			{
				index = j;
				min = Arrs[j];
			}
			
		}
		temp = Arrs[i];
		Arrs[i]=Arrs[index];
		Arrs[index]=temp;
	}
}

void BubSort(double Arrs[], int n)
{
	for(int i=0;i<n;i++)
	{
		
	}
}

void QukSort(double Arrs[], int n)
{
	
}

