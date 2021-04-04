# discord_dl Download and update discord for Linux
# Copyright (C) 2021  Mathias Schmitt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROG_NAME := discord_dl
SRC := discord_dl.sh

MAN_DIR := man
MAN := ${PROG_NAME}.1
INSTALL_DIR := /usr/local/bin
INSTALL_MAN_DIR := /usr/local/share/man/man1
INSTALL_MAN_DIR_FR := /usr/local/share/man/fr/man1

.PHONY: install
install: install_man
	@cp ${SRC} ${INSTALL_DIR}/${PROG_NAME}
	@chmod u+x,g+x,a+x ${INSTALL_DIR}/${PROG_NAME}

.PHONY: uninstall
uninstall: uninstall_man
	@rm ${INSTALL_DIR}/${PROG_NAME}

.PHONY: install_man
install_man:
	@mkdir -p ${DESTDIR}${INSTALL_MAN_DIR}
	@cp ${MAN_DIR}/${MAN} ${DESTDIR}${INSTALL_MAN_DIR}/${MAN}

	@mkdir -p ${DESTDIR}${INSTALL_MAN_DIR_FR}
	@cp ${MAN_DIR}/fr/${MAN} ${DESTDIR}${INSTALL_MAN_DIR_FR}/${MAN}

.PHONY: uninstall_man
uninstall_man:
	@rm ${DESTDIR}${INSTALL_MAN_DIR}/${MAN}
	@rm ${DESTDIR}${INSTALL_MAN_DIR_FR}/${MAN}

.PHONY: help
help:
	@echo "Use one of the following targets:"
	@echo "  help      Print this help message"
	@echo "  install   Install discord_dl on your system"
	@echo "  uninstall Uninstall discord_dl on your system"
