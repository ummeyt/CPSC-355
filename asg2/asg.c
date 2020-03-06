#include<stdio.h>
#define FALSE 0
#define TRUE 1

int main()

{
  int multiplier, multiplicand, product, i, negative;
  long int result, temp1, temp2;

  // Initialize variables

  multiplicand = -16384;
  multiplier = -64;
  product = 0;

  // Print out initial values of variables

  printf("multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n",
	 multiplier, multiplier, multiplicand, multiplicand);

  // Determine if multiplier is negative

  negative = multiplier < 0 ? TRUE : FALSE;

  // Do repeated add and shift

  for (i = 0; i < 32; i++) {
    if (multiplier & 0x1) {
      product = product + multiplicand;
    }
    // Arithmetic shift right the combined product and multiplier

    multiplier = multiplier >> 1;
    if (product & 0x1) {
      multiplier = multiplier | 0x80000000;
    } else {
      multiplier = multiplier & 0x7FFFFFFF;
    }
    product = product >> 1;
  }
  // Adjust product register if multiplier is negative

  if (negative) {
    product = product - multiplicand;
  }

  // Print out product and multiplier

  printf("product = 0x%08x multiplier = 0x%08x\n",
	 product, multiplier);

  // Combine product and multiplier together

  temp1 = (long int)product;
  //  printf("temp1 = 0x%0161x (%ld)\n", temp1);
  temp1 = temp1 << 32;
  // printf("temp1 = 0x%0161x (%ld)\n", temp1);
  temp2 = (long int)multiplier & 0xFFFFFFFF;
  //printf("temp2 = 0x%0161x (%ld)\n", temp2);
  result = temp1 + temp2;

  // Print out 64-bit result

  printf("64-bit result = 0x%016lx (%ld)\n", result, result);
  
  return 0;
}
