#include <iostream>
#include <fstream>
#include <string>
using namespace std;



struct SubType
{
	int value;
	SubType *next;
};
struct NodeType
{
	int value;
	NodeType *list;
	SubType *parts;
	bool checked;
};

void Checkoff (NodeType*&,int&,int&,ofstream&);
void Countcomponents(NodeType*&,int&,int&,ofstream&);
void Addtolist(NodeType*&, int, int);
void Addtocomps(NodeType*&, int);
void Addtosub(NodeType*&,int);
void InList(NodeType*&,int,int,bool&,bool&,bool&);


int main()
{
	ifstream infile;
	ofstream outfile;
	NodeType *initial, *dummy;
	string File;
	int Number;
	int first, second;
	int counter=0;
	int edges = 0;

    cout<< "Please Input a file name" << endl;
	cin>>File;
	infile.open(File.c_str());
	infile>>Number;
	initial = new NodeType;

	initial->value = Number;
	initial->list=NULL;
	initial->parts=NULL;
	initial->checked = false;

	infile >> first;
	infile >> second;
	while (infile)
	{
		Addtolist(initial, first, second);
		infile >> first;
		if(infile)
		{
			infile >> second;
		}
	}
	infile.close();
	outfile.open("Numbers.txt");
	Countcomponents(initial, counter,edges, outfile);
	outfile.close();
	outfile.open ("HW5.txt");
	outfile << "There are " << counter << " components" << endl;
	outfile << "There are " << edges << " edges" <<endl;

	counter = 0;
	dummy = initial;
	while(dummy->list != NULL)
	{
		counter++;
		dummy = dummy->list;
	}
	counter++;

	outfile << "There are  " << counter << " vertices" << endl;

	infile.open ("Numbers.txt");
	infile >> Number;
	while(infile)
	{
		if(Number==1024)
		{
			outfile << endl;
		}
		else
		{
			outfile << Number << " ";
		}
		infile >> Number;
	}

	outfile.close();
	infile.close();

return 0;
}

void Countcomponents(NodeType*& initial, int& x,int& y, ofstream& outfile)
{
	NodeType *nav;
	SubType *snav;
	nav = initial;
	y=0;
	ofstream outerfile;

	while(nav!=NULL)
	{
		if(nav->checked==false)
		{
			Checkoff(nav,x,y,outfile);
			outfile << " " << 1024 << endl;
		}

		nav = nav->list;
	}
	outerfile.open("HW5.txt");
	outerfile << "There are " << y << " edges" << endl;
	outerfile.close();
}

void Checkoff (NodeType*& initial,int& x,int& y, ofstream& outfile)
{
	SubType *nextup;
	NodeType *dummy,*nav,*ahead;
	int findref;

	dummy = initial;
	nav = initial;
	bool u;
	u = true;

	while(u!=false)
	{
	    if(nav->list == NULL)
        {
            u = false;
        }
	    else
        {
            if(nav->parts!=NULL)
		{
			nextup = nav->parts;
			while(nav->parts!=NULL and nextup->next!=NULL)
			{
				findref = nextup->value;
				dummy = initial;
				while(dummy->value!= findref)
				{
					dummy = dummy->list;
				}
				if(dummy->checked==false)
				{
					dummy->checked = true;
					outfile << dummy->value;
					y++;
				}
				nextup=nextup->next;
			}
			findref = nextup->value;
			dummy = initial;
			while(dummy->value!=findref)
			{
				dummy = dummy->list;
			}
			if(dummy->checked==false)
			{
				dummy->checked = true;
				outfile << dummy->value;
				y++;
			}

		}
		nav = nav->list;
		bool g = true;
		while(nav->checked==true and g !=false)
		{


			if(nav->list == NULL)
            {
                g=false;

            }
            else
            {
                nav=nav->list;
            }

		}

        }

	}
	x++;


}

void Addtolist(NodeType*& initial, int first, int second)
{
	NodeType *dummy;
	SubType *dumdum;
	bool x,y,z;
	InList(initial,first,second,x,y,z);

	if(x==true and y==false)
	{
		dummy = initial;
		while(dummy->value!=first)
		{
			dummy=dummy->list;
		}
		Addtosub(dummy,second);
		Addtocomps(initial,second);
		dummy = initial;
		while(dummy->value!=second)
		{
			dummy=dummy->list;
		}
		Addtosub(dummy,first);
	}
	else if(x==false and y==true)
	{
		dummy = initial;
		while(dummy->value!=second)
		{
			dummy=dummy->list;
		}
		Addtosub(dummy,first);
		Addtocomps(initial,first);
		dummy = initial;
		while(dummy->value!=first)
		{
			dummy=dummy->list;
		}
		Addtosub(dummy,second);
	}
	else if (x==true and y==true)
	{
		if(z==true)
		{
			return;
		}
		else if(z==false)
		{
			dummy = initial;
			while(dummy->value!=first)
			{
				dummy = dummy->list;
			}
			Addtosub(dummy,second);
			dummy = initial;
			while(dummy->value!=second)
			{
				dummy = dummy->list;
			}
			Addtosub(dummy,first);
		}
	}
	else if(x==false and y==false)
	{
        Addtocomps(initial,first);
        dummy = initial;
        int h = dummy->value;
        while(dummy->value!=first)
        {
            dummy=dummy->list;
        }
        Addtosub(dummy,second);
        Addtocomps(initial,second);
        dummy = initial;
        while(dummy->value!=second)
        {
            dummy=dummy->list;
        }
        Addtosub(dummy,first);
	}
}

void Addtocomps(NodeType*& initial, int n)
{
	NodeType *inserter, *dummy,*past;

	inserter = new NodeType;
	inserter->value = n;
	inserter->list = NULL;
	inserter->checked = false;
	inserter->parts = NULL;

	past = initial;
	dummy = initial;
	while(dummy->value < n and dummy->list!= NULL)
	{
		past = dummy;
		dummy = dummy->list;
	}
	if(initial->value > n)
	{
		inserter->list = initial;
		initial = inserter;
	}
	else if(dummy->list == NULL)
	{
		if(dummy->value < n)
		{
			dummy->list = inserter;
			inserter->list = NULL;
		}
		if(dummy->value > n)
		{
			past->list = inserter;
			inserter->list = dummy;
		}
	}
	else
	{
		past->list = inserter;
		inserter->list = dummy;
	}

}

void Addtosub (NodeType*& initial, int n)
{
	SubType *inserter,*dummy,*past;
	inserter = new SubType;
	inserter->value = n;
	inserter->next = NULL;


	if(initial->parts == NULL)
	{
		initial->parts = inserter;
		return;
	}
	past = initial->parts;
	dummy = initial->parts;
	if(past->value > n)
	{
	    initial->parts = inserter;
		inserter->next = past;
		return;
	}
	while (dummy->value < n and dummy->next !=NULL)
	{
		past = dummy;
		dummy = dummy->next;
	}
	if(dummy->next==NULL)
	{
		if(dummy->value < n)
		{
			dummy->next = inserter;
			inserter->next == NULL;
		}
		if(dummy->value > n)
		{
			past->next = inserter;
			inserter->next = dummy;
		}
	}
	else
	{
		past->next = inserter;
		inserter->next = dummy;
	}

}

void InList (NodeType*& initial, int first, int second, bool& x, bool& y, bool& z)
{
	NodeType *dummy;
	SubType *dum2;

	dummy = initial;
	while(dummy->value!=first and dummy->list!=NULL)
	{
		dummy = dummy->list;
	}
	if(dummy->list == NULL)
	{
		if(dummy->value == first)
		{
			x = true;
		}
		else
		{
			x = false;
		}
	}
	else
	{
		x=true;
	}

	dummy = initial;
	while(dummy->value!=second and dummy->list!=NULL)
	{
		dummy = dummy->list;
	}
	if(dummy->list == NULL)
	{
		if(dummy->value == first)
		{
			y = true;
		}
		else
		{
			y = false;
		}
	}
	else
	{
		y=true;
	}

	if(x==true and y==true)
	{
		dummy = initial;
		while(dummy->value!=first)
		{
			dummy = dummy->list;
		}
		dum2 = dummy->parts;
		while(dum2->value!=second and dum2->next!=NULL)
		{
			dum2 = dum2->next;
		}
		if(dum2->next==NULL)
		{
			if(dum2->value == second)
			{
				z = true;
			}
			else
			{
				z = false;
			}
		}
		else
		{
			z = true;
		}

	}
	else
    {
        z=false;
    }


}



