const int pinX = 2;   // SW1 - Push Button X
const int pinY = 3;   // SW2 - Push Button Y
const int pinZ = 4;   // SW3 - Push Button Z
const int pinF = 5;   // LED1 Output

void setup() {
    pinMode(pinX, INPUT);   // External 10kΩ pull-down on R1
    pinMode(pinY, INPUT);   // External 10kΩ pull-down on R2
    pinMode(pinZ, INPUT);   // External 10kΩ pull-down on R3
    pinMode(pinF, OUTPUT);
    Serial.begin(9600);
}

void loop() {
    bool X = digitalRead(pinX);
    bool Y = digitalRead(pinY);
    bool Z = digitalRead(pinZ);

    // Majority gate: F = XY + YZ + ZX
    bool F = (X & Y) | (Y & Z) | (Z & X);

    digitalWrite(pinF, F);  // Drives LED1 via R4 (220Ω)

    Serial.print("X="); Serial.print(X);
    Serial.print(" Y="); Serial.print(Y);
    Serial.print(" Z="); Serial.print(Z);
    Serial.print("  =>  F="); Serial.println(F);

    delay(200);
}