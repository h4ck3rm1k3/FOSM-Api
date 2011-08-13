class Soldier {
 public:
  Soldier(char *name, char *rank, int serial);

  char *get_name();
  char *get_rank();
  int get_serial();

 private:
  char *name;
  char *rank;
  int serial;
};

Soldier::Soldier(char *name, char *rank, int serial) {
   this->name = name;
   this->rank = rank;
   this->serial = serial;
}

char *Soldier::get_name() {
    return name;
}

char *Soldier::get_rank() {
    return rank;
}

int Soldier::get_serial() {
    return serial;
}
