
void
UART::putch(char ch) {
  while ( !(UCSR0A & (1<<UDRE0)) );
  UDR0 = ch;
}
