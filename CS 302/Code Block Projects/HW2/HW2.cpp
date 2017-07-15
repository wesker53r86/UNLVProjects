#include <iostream>
#include <fstream>


using namespace std;

void SecSort(double[], int, int&);
void BubSort(double[], int, int&);
void QukSort(double[], int, int, int&);



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

	int kount = 0;


	if(input == "S")
	{
		SecSort(Arrs, n,kount);
	}
	if(input == "B")
	{
        BubSort(Arrs, n,kount);
	}
	if(input == "Q")
	{
		int hi = n-1;
		int lo = 0;

		QukSort(Arrs,lo,hi,kount);

	}

	cout<< "# of comparisons: " << kount<< endl;
	cout<< "results are in file named 'HW2.txt' "<< endl;

	outFile.open("HW2.txt");

	for(int i=0; i<n;i++)
	{
		outFile<< Arrs[i] << endl;
	}

	outFile.close();


return 0;

}



void SecSort(double Arrs[], int n, int& kount)
{
	double temp;
	double min;
	int index;
	for(int i=0;i<n;i++)
	{
	    kount++;
		min = Arrs[i];
		for(int j=i+1;j<n;j++)
		{
		    kount++;
			if(min>Arrs[j])
			{
				swap(Arrs[i],Arrs[j]);
				min=Arrs[i];
			}

		}

	}
}

void BubSort(double Arrs[], int x,int& kount)
{
	double temp;
	int n = x;
	n=n-1;
	for(int i=0;i<n;i++)
	{
	    kount++;
		for(int j=0;j<(n-i);j++)
			{
			    kount++;
				if(Arrs[j]>Arrs[j+1])
				{
					swap(Arrs[j],Arrs[j+1]);
					kount++;
				}
			}
	}
}

void QukSort(double Arrs[], int lo, int hi,int& kount)
{
	int first = lo;
	int last = hi;
	double temp;
    int piv;
    double pival;

    if(lo<hi)
    {

            piv = (lo+hi)/2;
            pival = Arrs[piv];

            while(last>first)
            {
                double testfirst = Arrs[first];
                double testlast = Arrs[last];

                while(Arrs[first]<=pival and first!=last) first++;
                while(Arrs[last]>pival and last!=first) last--;



                testfirst = Arrs[first];
                testlast = Arrs[last];

                if(Arrs[first]>pival and Arrs[last]<=pival)
                            {
                                temp=Arrs[first];
                                Arrs[first]=Arrs[last];
                                Arrs[last]=temp;
                                kount++;
                            }

            }


            QukSort(Arrs,lo,first,kount);
            QukSort(Arrs,first+1,hi,kount);

    }

return;
}

