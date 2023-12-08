#
#  Copyright 2022, Roger Brown
#
#  This file is part of rhubarb pi.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#
#  $Id: Makefile 172 2022-07-02 21:48:38Z rhubarb-geek-nz $

GITROOT=jansi.git
GITDIR=$(GITROOT)\src\main\native
SRC=$(GITDIR)\jansi.c $(GITDIR)\jansi_isatty.c $(GITDIR)\jansi_structs.c 
OBJDIR=obj\$(PLATFORM)
BINDIR=bin\$(PLATFORM)
JANSIDLL=$(BINDIR)\jansi.dll
GITBRANCH=jansi-2.4.0

all: $(JANSIDLL)

clean:
	if exist $(OBJDIR) rmdir /q /s $(OBJDIR)
	if exist $(BINDIR) rmdir /q /s $(BINDIR)

$(OBJDIR) $(BINDIR):
	mkdir $@

$(GITROOT):
	git clone --branch $(GITBRANCH) --single-branch https://github.com/fusesource/jansi.git $(GITROOT)
	cd $(GITROOT)
	git apply ..\$(GITBRANCH).diff
	cd ..

$(JANSIDLL): $(GITROOT) $(SRC) $(OBJDIR) $(BINDIR) jansi.def
	cl 								\
		/LD /Fe$@ 						\
		/Fo$(OBJDIR)\						\
		/W3 							\
		/WX 							\
		/I$(GITDIR)						\
		/I$(GITDIR)\inc_win					\
		/DUNICODE						\
		/DNDEBUG 						\
		/D_CRT_SECURE_NO_DEPRECATE 				\
		/D_CRT_NONSTDC_NO_DEPRECATE  				\
		$(SRC) 							\
		/link							\
		/INCREMENTAL:NO						\
		/PDB:NONE						\
		/DEF:jansi.def						\
		/SUBSYSTEM:CONSOLE
