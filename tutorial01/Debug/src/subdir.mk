################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/Create\ a\ window.cpp 

OBJS += \
./src/Create\ a\ window.o 

CPP_DEPS += \
./src/Create\ a\ window.d 


# Each subdirectory must supply rules for building sources it contributes
src/Create\ a\ window.o: ../src/Create\ a\ window.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"src/Create a window.d" -MT"src/Create\ a\ window.d" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


