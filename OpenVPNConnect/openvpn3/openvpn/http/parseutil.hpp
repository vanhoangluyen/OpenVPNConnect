//    OpenVPN -- An application to securely tunnel IP networks
//               over a single port, with support for SSL/TLS-based
//               session authentication and key exchange,
//               packet encryption, packet authentication, and
//               packet compression.
//
//    Copyright (C) 2013-2014 OpenVPN Technologies, Inc.
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Affero General Public License Version 3
//    as published by the Free Software Foundation.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Affero General Public License for more details.
//
//    You should have received a copy of the GNU Affero General Public License
//    along with this program in the COPYING file.
//    If not, see <http://www.gnu.org/licenses/>.

// Common utility methods for HTTP classes

#ifndef OPENVPN_HTTP_PARSEUTIL_H
#define OPENVPN_HTTP_PARSEUTIL_H

namespace openvpn {
  namespace HTTP {
    namespace Util {

      // Check if a byte is an HTTP character.
      inline bool is_char(int c)
      {
	return c >= 0 && c <= 127;
      }

      // Check if a byte is an HTTP control character.
      inline bool is_ctl(int c)
      {
	return (c >= 0 && c <= 31) || (c == 127);
      }

      // Check if a byte is defined as an HTTP tspecial character.
      inline bool is_tspecial(int c)
      {
	switch (c)
	  {
	  case '(': case ')': case '<': case '>': case '@':
	  case ',': case ';': case ':': case '\\': case '"':
	  case '/': case '[': case ']': case '?': case '=':
	  case '{': case '}': case ' ': case '\t':
	    return true;
	  default:
	    return false;
	  }
      }

      // Check if a byte is a digit.
      inline bool is_digit(int c)
      {
	return c >= '0' && c <= '9';
      }
    }
  }
}

#endif
