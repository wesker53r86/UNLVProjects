#include <iostream>
#include <fstream>


using namespace std;

void SecSort(double[], int);
void BubSort(double[], int);
void QukSort(double[], int, int);



int main()
{
	ifstream inFile;
	ofstream outFile;
	string file;


	double Arrs[1000];
	double num;
	int n;
	string input;

	cout << "Enter the name of the file."<< endl;
	cin >> file;
	inFile.open(file.c_str());
	inFile>>num;
	n=0;
	while(inFile)
	{
		Arrs[n]=num;
		n++;
		inFile>>num;
	}

	inFile.close();

	cout << "Press S for SecSort, B for BubSort, or Q for QukSort" << endl;
	cin >> input;


	if(input == "S")
	{
		
		SecSort(Arrs, n);
	}
	if(input == "B")
	{
		BubSort(Arrs, n);
	}
	if(input == "Q")
	{
		int hi = n;
		int lo = 0;

		QukSort(Arrs,lo,hi);

	}

	outFile.open("HW2.txt");

	for(int i=0; i<n;i++)
	{
		outFile<< Arrs[i] << endl;
	}

	outFile.close();


return 0;

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
	double temp;
	for(int i=0;i<n;i++)
	{
		for(int j=i;j<n;j++)
			{
				if(Arrs[j]<Arrs[j+1])
				{
					temp = Arrs[j];
					Arrs[j]=Arrs[j+1];
					Arrs[j+1]=temp;
				}
			}
	}
}

void QukSort(double Arrs[], int lo, int hi)
{
	int first = lo;
	int last = hi;
	double temp;
    int piv;
    int pival;

	if(lo!=hi)
	{
		while(first<last)
		{
			 piv = (lo+hi)/2;
			 pival = Arrs[piv];

			if(Arrs[first]<=pival) first++;
			if(Arrs[last]>=pival) last--;

			if(Arrs[first]>=pival and Arrs[last]<=pival)
			{
				temp=Arrs[first];
				Arrs[first]=Arrs[last];
				Arrs[last]=temp;
			}
		}

	QukSort(Arrs,lo,piv);
	QukSort(Arrs,(piv+1),hi);
	}

return;
}

