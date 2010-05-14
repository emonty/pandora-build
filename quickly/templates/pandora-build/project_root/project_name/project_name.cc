/* BEGIN LICENSE
 * END LICENSE */

#include "config.h"

#include "project_name.h"

namespace project_name
{

project_name::project_name(const std::string &input) :
  name(input)
{ }

project_name::project_name(const char *input) :
  name(input)
{ }

} /* namespace project_name */
