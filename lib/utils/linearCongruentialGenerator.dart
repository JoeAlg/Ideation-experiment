// https://en.wikipedia.org/wiki/Linear_congruential_generator
String invitationCodeLCG(int seed){
  int a = 456789;
  int c = 42;
  int m = 999999;
  int lcg =  (a * (seed-1) + c) % m;
  return lcg.toString().padLeft(6,'0');
}