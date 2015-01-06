################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/common/controls.cpp \
../src/common/objloader.cpp \
../src/common/quaternion_utils.cpp \
../src/common/shader.cpp \
../src/common/tangentspace.cpp \
../src/common/text2D.cpp \
../src/common/texture.cpp \
../src/common/vboindexer.cpp 

OBJS += \
./src/common/controls.o \
./src/common/objloader.o \
./src/common/quaternion_utils.o \
./src/common/shader.o \
./src/common/tangentspace.o \
./src/common/text2D.o \
./src/common/texture.o \
./src/common/vboindexer.o 

CPP_DEPS += \
./src/common/controls.d \
./src/common/objloader.d \
./src/common/quaternion_utils.d \
./src/common/shader.d \
./src/common/tangentspace.d \
./src/common/text2D.d \
./src/common/texture.d \
./src/common/vboindexer.d 


# Each subdirectory must supply rules for building sources it contributes
src/common/%.o: ../src/common/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


