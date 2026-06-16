#include <Arduino.h>
#include <avr/io.h>
#include <util/delay.h>

const int pinX = 2;
const int pinY = 3;
const int pinZ = 4;
const int pinF = 5;

void setup() {
    // D2, D3, D4 as inputs (external pull-downs R1/R2/R3 handle idle state)
    DDRD &= ~((1 << pinX) | (1 << pinY) | (1 << pinZ));
    // D5 as output (drives LED1 through R4 220Ω)
    DDRD |= (1 << pinF);
}

void loop() {
    bool X = (PIND >> pinX) & 1;
    bool Y = (PIND >> pinY) & 1;
    bool Z = (PIND >> pinZ) & 1;

    // Majority gate: F = XY + YZ + ZX
    bool F = (X & Y) | (Y & Z) | (Z & X);

    if (F) PORTD |=  (1 << pinF);
    else   PORTD &= ~(1 << pinF);

    _delay_ms(200);
}

int main() {
    setup();
    while (1) { loop(); }
    return 0;
}