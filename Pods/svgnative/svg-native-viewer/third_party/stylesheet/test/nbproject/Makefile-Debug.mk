#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Environment
MKDIR=mkdir
CP=cp
CCADMIN=CCadmin
RANLIB=ranlib
CC=gcc
CCC=g++
CXX=g++
FC=
AS=as

# Macros
CND_PLATFORM=GNU-Linux-x86
CND_CONF=Debug
CND_DISTDIR=dist

# Include project Makefile
include Makefile

# Object Directory
OBJECTDIR=build/${CND_CONF}/${CND_PLATFORM}

# Object Files
OBJECTFILES= \
	${OBJECTDIR}/src/TestElement.o \
	${OBJECTDIR}/src/TestSelector.o \
	${OBJECTDIR}/src/TestStyleSheet.o \
	${OBJECTDIR}/src/TestParser.o \
	${OBJECTDIR}/src/TestProperty.o

# C Compiler Flags
CFLAGS=

# CC Compiler Flags
CCFLAGS=
CXXFLAGS=

# Fortran Compiler Flags
FFLAGS=

# Assembler Flags
ASFLAGS=

# Link Libraries and Options
LDLIBSOPTIONS=-lgtest_main

# Build Targets
.build-conf: ${BUILD_SUBPROJECTS}
	${MAKE}  -f nbproject/Makefile-Debug.mk dist/Debug/GNU-Linux-x86/test

dist/Debug/GNU-Linux-x86/test: ${OBJECTFILES}
	${MKDIR} -p dist/Debug/GNU-Linux-x86
	${LINK.cc} -o ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/test ${OBJECTFILES} ${LDLIBSOPTIONS} 

${OBJECTDIR}/src/TestElement.o: nbproject/Makefile-${CND_CONF}.mk src/TestElement.cpp 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.cc) -g -D_DEBUG -I../include -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/TestElement.o src/TestElement.cpp

${OBJECTDIR}/src/TestSelector.o: nbproject/Makefile-${CND_CONF}.mk src/TestSelector.cpp 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.cc) -g -D_DEBUG -I../include -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/TestSelector.o src/TestSelector.cpp

${OBJECTDIR}/src/TestStyleSheet.o: nbproject/Makefile-${CND_CONF}.mk src/TestStyleSheet.cpp 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.cc) -g -D_DEBUG -I../include -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/TestStyleSheet.o src/TestStyleSheet.cpp

${OBJECTDIR}/src/TestParser.o: nbproject/Makefile-${CND_CONF}.mk src/TestParser.cpp 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.cc) -g -D_DEBUG -I../include -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/TestParser.o src/TestParser.cpp

${OBJECTDIR}/src/TestProperty.o: nbproject/Makefile-${CND_CONF}.mk src/TestProperty.cpp 
	${MKDIR} -p ${OBJECTDIR}/src
	${RM} $@.d
	$(COMPILE.cc) -g -D_DEBUG -I../include -MMD -MP -MF $@.d -o ${OBJECTDIR}/src/TestProperty.o src/TestProperty.cpp

# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf:
	${RM} -r build/Debug
	${RM} dist/Debug/GNU-Linux-x86/test

# Subprojects
.clean-subprojects:

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
