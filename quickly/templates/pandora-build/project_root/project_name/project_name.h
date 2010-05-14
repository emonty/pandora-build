/* BEGIN LICENSE
 * END LICENSE */

/**
 * @file
 * @brief A Basic Example Class
 */

#ifndef all_caps_name_all_caps_name_H
#define all_caps_name_all_caps_name_H

#include "project_name/visibility.h"

#include <string>

namespace project_name
{

/**
 * The main class implementing project_name
 */
class all_caps_name_API project_name
{
  const std::string name;

public:

  explicit project_name(const std::string &input);
  explicit project_name(const char *input);

  virtual ~project_name();

  /**
   * Get the name of this project_name
   */
  const std::string &get_name() const;

private:
  
  /**
   * Don't allow default construction.
   */
  project_name();

  /**
   * Don't allow copying of objects.
   */
  project_name(const project_name &);

  /**
   * Don't allow assignment of objects.
   */
  project_name& operator=(const project_name &);
};

/*
 * Public methods.
 */
inline project_name::~project_name()
{ }

inline const std::string &project_name::get_name() const
{
  return name;
}

} /* namespace project_name */

#endif /* all_caps_name_all_caps_name_H */
