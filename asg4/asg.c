#define FALSE 0
#define TRUE 1

struct point {
  int x, y;
};

struct dimension {
  int width, length;
};

struct pyramid {
  struct point origin;
  struct dimension base;
  int height;
  int volume;
};

struct pyramid newPyramid()
{
  struct pyramid p;
  p.origin.x = 0;
  p.origin.y = 0;
  p.base.width = 2;
  p.base.length = 2;
  p.height = 3;
  p.volume = (p.base.width * p.base.length * p.height) / 3;

  return p;
}

void move(struct pyramid *p, int deltaX, int deltaY)
{
  p->origin.x += deltaX;
  p->origin.y += deltaY;
}

void scale(struct pyramid *p, int factor)
{
  p->base.width *= factor;
  p->base.length *= factor;
  p->height *= factor;
  p->volume = (p->base.width * p->base.length * p->height) / 3;
}

void printPyramid(char *name, struct pyramid *p)
{
  printf("Pyramid %s origin = (%d, %d)\n", name, p->origin.x, p->origin.y);
  printf("\tBase width = %d Base length = %d\n", p->base.width,
	 p->base.length);
  printf("\tHeight = %d\n", p->height);
  printf("\tVolume = %d\n\n", p->volume);
}

int equalSize(struct pyramid *p1, struct pyramid *p2)
{
  int result = FALSE;
  if (p1->base.width == p2->base.width) {
    if (p1->base.length == p2->base.length) {
      if (p1->height == p2->height) {
	result = TRUE;
      }
    }
  }
  return result;
}

int main()
{
  struct pyramid first, second;
  first = newPyramid();
  second = newPyramid();

  printf("Initial pyramid values:\n");
  printPyramid("first", &first);
  printPyramid("second", &second);

  if (equalSize(&first, &second)) {
    move(&first, -5, 7);
    scale(&second, 3);
  }

  printf("\nChanged pyramid values:\n");
  printPyramid("first", &first);
  printPyramid("second", &second);
}
