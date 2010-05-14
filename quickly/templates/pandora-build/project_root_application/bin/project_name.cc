/* BEGIN LICENSE
 * END LICENSE */

#include "config.h"

#include <iostream>

#include "project_name/project_name.h"

int main(int, char**)
{
  const project_name::project_name the_project_name("sentence_name");
  std::cout << the_project_name.get_name() << std::endl;
  return 0;
}
