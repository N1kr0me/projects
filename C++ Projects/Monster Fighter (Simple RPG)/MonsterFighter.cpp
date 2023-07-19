#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int main()
{
  int choice;
  int Monster_Health, Player_Health, i, init, Player_Attack, Player_Defense, Monster_Atk, Monster_Def, Player_Damage, Monster_Damage, Player_Agility, Monster_Agility;
  Player_Attack = 10;
  Player_Defense = 15;
  Player_Agility = 5;
  Monster_Atk = 10;
  Monster_Def = 15;
  Monster_Agility = 5;
  
  srand((unsigned)time(0));
  init = rand()%2+1;
  Monster_Health = rand()%50 + 60;
  Player_Health = rand()%20 + 80;
  if (init == 1) {
    cout<<"=============\t Welcome to Monster Fighter \t=============";
    cout<<"\nYou are the Hope in this Fight. Defeat the Monster\n";
    cout<<"\nYou start with "<<Player_Health<<" Health\n";
  cout<<"You start the fight.\n==========\n";
  while (Player_Health > 0 || Monster_Health > 0) {
    cout<<"What do you want to do?\n1 - Melee Attack\n2 - Magic Attack\n3 - Defend/Parry \n";
     do{cin>>choice;}while(choice>3 || choice<1);
    switch (choice) {
      case 1: 
        Player_Attack = rand()%20+10;
        Player_Defense = rand()%10+10;
        Player_Agility = rand()%5;
    break;
      case 2:
        Player_Attack = rand()%5+10;
        Player_Defense = rand()%10+10;
        Player_Agility = rand()%15;
        break;
      case 3:
        Player_Attack = rand()%10+10;
        Player_Defense =rand()%20+10;
        Player_Agility =rand()%5;
    break;
    }
    choice = rand()%3;
    switch (choice) {
      case 1:
        Monster_Atk = rand()%20+10;
        Monster_Def = rand()%10+10;
        Monster_Agility = rand()%5;
        break;
      case 2:
        Monster_Atk = rand()%5+10;
        Monster_Def = rand()%10+10;
        Monster_Agility = rand()%15;
        break;
      case 3:
        Monster_Atk = rand()%10+10;
        Monster_Def = rand()%20+10;
        Monster_Agility = rand()%5;
        break;
    }


    Monster_Damage = (Player_Attack - Monster_Agility) -  (Monster_Def/Player_Attack);
    if (Monster_Damage < 0) {
      Monster_Damage = 0;
    }
    Monster_Health = Monster_Health - Monster_Damage;
    cout<<"You did "<<Monster_Damage<<" damage to the monster!\n";
    cin.get();

    if (Monster_Health < 1) {
      cout<<"You killed the beast!! You won with "<<Player_Health<<" Health left.\n";
      cin.get();
      return 0;
       }
    cout<<"The monster now have "<<Monster_Health<<" Health left.\n";
    Player_Damage = (Monster_Atk - Player_Agility) - (Player_Defense/Monster_Atk);
    if (Player_Damage < 0) {
       Player_Damage = 0;
    }
    Player_Health = Player_Health - Player_Damage;
    cout<<"The monster hit you for "<<Player_Damage<<" damage.\n";

    if (Player_Health < 1) {
      cout<<"You died. The beast still has "<<Monster_Health<<" Health left.\n";
      cin.get();
      return 0;
    }
    cout<<"You now have "<<Player_Health<<" Health left.\n\n";
    }
    }
    else {
        cout<<"=============\t Welcome to Monster Fighter \t=============";
        cout<<"\nYou are the Hope in this Fight. Defeat the Monster.\n";
        cout<<"\nYou start with "<<Player_Health<<" Health\n";
        cout<<"Monster start.\n==============\n";
        while (Player_Health > 0 || Monster_Health > 0) {
           choice = rand()%3;
    switch (choice) {
       case 1:
            Monster_Atk = rand()%20+10;
            Monster_Def = rand()%10+10;
            Monster_Agility = rand()%5;
            break;
        case 2:
            Monster_Atk = rand()%5+10;
            Monster_Def = rand()%10+10;
            Monster_Agility = rand()%15;
            break;
      case 3:
            Monster_Atk = rand()%10+10;
            Monster_Def = rand()%20+10;
            Monster_Agility = rand()%5;
            break;
    }

        Player_Damage = (Monster_Atk - Player_Agility) - (Player_Defense/Monster_Atk);
           if (Player_Damage < 0) {
      Player_Damage = 0;
    }
    Player_Health = Player_Health - Player_Damage;
    cout<<"The monster hit you for "<<Player_Damage<<" damage.\n";

     if (Player_Health < 1) {
      cout<<"You died. The beast still has "<<Monster_Health<<" Health left.\n";
       cin.get();
       return 0;
       }
  cout<<"You now have "<<Player_Health<<" Health left.\n\n";
     cout<<"What do you want to do?\n1 - Melee Attack\n2 - Magic Attack\n3 - Defend/Parry \n";
     do{cin>>choice;}while(choice>3 ||  choice<1);
    switch (choice) {
      case 1: 
        Player_Attack = rand()%20+10;
        Player_Defense = rand()%10+10;
        Player_Agility = rand()%5;
        break;
      case 2:
        Player_Attack = rand()%5+10;
        Player_Defense = rand()%10+10;
        Player_Agility = rand()%15;
        break;
      case 3:
        Player_Attack = rand()%10+10;
        Player_Defense = rand()%20+10;
        Player_Agility = rand()%5;
        break;
    }       



    Monster_Damage = (Player_Attack - Monster_Agility) -  (Monster_Def/Player_Attack);
    if (Monster_Damage < 0) {
      Monster_Damage = 0;
    }
    Monster_Health = Monster_Health - Monster_Damage;
    cout<<"You did "<<Monster_Damage<<" damage to the monster!\n";
    cin.get();

    if (Monster_Health < 1) {
      cout<<"You killed the beast!! You won with "<<Player_Health<<" Health left.\n";
      cin.get();
      return 0;
       }
    cout <<"The monster now have "<<Monster_Health<<" Health left.\n";
   } } }        