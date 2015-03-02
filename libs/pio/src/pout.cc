
void POUT::init(){ *ddr &= ~(1<<bit); }
void POUT::set() { *ddr |=   1<<bit; }
void POUT::clr() { *port&=   1<<bit; }
void POUT::set(fint val) {
  if (val==0) this->set();
  else        this->clr();

}
