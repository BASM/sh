
void
UART::putch(char ch) {
  while ( !(UCSR0A & (1<<UDRE0)) );
  UDR0 = ch;
}

fint
UART::getch(bool block) {
  if (block==true)  while ( (UCSR0A & (1<<RXC0)) ==0 );
  else              if ( ! (UCSR0A & (1<<RXC0)) )
                        return 1;
  return UDR0;
}


//UART::~UART() {}
