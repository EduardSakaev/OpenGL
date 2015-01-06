There is Open GL tutorials. 
For compile projects for linux 
right click on project -> properties -> GCCC++Linker -> Libraries -> add(GL, GLU, glut, GLEW)


OpenGL Lessons!!!!
http://opengl-tutorial.blogspot.com/
material:
https://code.google.com/p/opengl-tutorial-org/source/browse/


local branch: hg clone https://code.google.com/p/opengl-tutorial-org/
need to copy common folder to /usr/local/include

1) Need to install GL libraries, glew, glfw, glm!!!!!

http://web.eecs.umich.edu/~sugih/courses/eecs487/glut-howto/
http://web.eecs.umich.edu/~sugih/courses/eecs487/glfw-howto/
http://sourceforge.net/projects/ogl-math/files/glm-0.9.6.1/glm-0.9.6.1.zip/download



    Download the GLFW source code zip (at least 3.0.4) from
    http://www.glfw.org/download.html

    Unzip the archive into some directory

    cd to that directory and type these commands:

        mkdir build 
        cd build						      
        cmake .. 
        make 
        sudo make install 

    [Ubuntu/Debian]

        apt-get install glew-utils libglew-dev

    [Fedora]

        yum install glew-utils libglew-dev

    GLM is a header only C++ library. Grab a recent zip file from
    http://glm.g-truc.net/ under Downloads.

    Extract the compressed file, which makes a glm folder. Inside of that folder is another glm folder. Copy the inner glm folder to /usr/local/include (using sudo).


///////////////////////////////////// 
Specific problems:
////////////////////////////////////

	Description	Resource	Path	Location	Type
	undefined reference to `glfwCreateWindow'	Create_Window.cpp	/Create_Window/src	line 39	C/C++ Problem

	Do it in this order:

	-lglfw3 -lGLU -lGL

	Instead of this one:

	-lGL -lGLU -lglfw3

/////////////////////////////////////
Description	Resource	Path	Location	Type
//usr/local/lib/libglfw3.a(x11_clipboard.c.o): undefined reference to symbol 'XConvertSelection'	Create_Window		 	C/C++ Problem

	First: error adding symbols: DSO missing from command line shows a wrong order of linker command line parameters. This post made me realise that. You need to call $ make VERBOSE=1 to see the linker call and check it with your own eyes. Remember: TARGET_LINK_LIBRARIES() should be the last command in your CMakeLists.txt And have a look at this order explanation.

Second: if you build against static GLFW3 libraries all the X11 libraries are not automatically added to your linker call, as atsui already showed above. In the GLFW-Documentation you can find a cmake variable which should fit your needs: ${GLFW_STATIC_LIBRARIES}. To make use of it and enable a more automatic build process, let pkg-config find all dependencies for X11 libs:

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(myProject)

FIND_PACKAGE( PkgConfig REQUIRED )
pkg_search_module( GLFW3 REQUIRED glfw3 ) # sets GLFW3 as prefix for glfw vars

# now ${GLFW3_INCLUDE_DIR}, ${GLFW3_LIBRARIES} and ${GLFW3_STATIC_LIBRARIES} 
# are set

INCLUDE_DIRECTORIES( ${GLFW3_INCLUDE_DIR} )
ADD_EXECUTABLE( myProject mySource.cpp )

TARGET_LINK_LIBRARIES( myProject ${GLFW_STATIC_LIBRARIES} )
# they include X11 libs

Now check the linker lib parameters again with $ make VERBOSE=1 and you should find many more X11 libs like: -lXrandr -lXi -lXrender -ldrm -lXdamage -lXxf86vm -lXext -lX11 and -lpthread.

Third: when linking against the shared library, the dependencies to X11 etc. are resolved dynamically. That is why you don't need to explicitly add X11 lib flags to the linker. In that case you only need: TARGET_LINK_LIBRARIES( myProject ${GLFW_LIBRARIES} )

Fourth: it happened to me, that some glfwCommands had undefined reference to - linker errors. I found out, that I installed GLFW3 in /usr/local/lib but the linker was given only the LD_LIBRARY_PATH environment variable which was only set to /usr/lib32. Adding the parameter -L/usr/local/lib solved the reference problem. To avoid it in future I've set LD_LIBRARY_PATH=/usr/lib32;/usr/local/lib;.

Hint: to check what values are in your GLFW cmake variables, print them during build:

FOREACH(item ${GLFW3_STATIC_LIBRARIES})
    MESSAGE(STATUS "  using lib: " ${item})
ENDFOREACH()
//////////////////////////////////////////////////////////////
	undefined reference to symbol 'XF86VidModeQueryExtension'
	

	The problem is here:

	LIBS += -lXxf86vm -L/usr/lib/x86_64-linux-gnu/libXxf86vm.so.1
	LIBS += -lXxf86vm -L/user/lib/x86_64-linux-gnu/libXxf86vm.so
	LIBS += -lXxf86vm -L/user/lib/x86_64-linux-gnu/libXxf86vm.a
	LIBS += -lXxf86vm -L/user/lib/x86_64-linux-gnu/libXxf86vm.so.1.0.0

	You are using the -L option with a file name rather than a path! You should change those four lines to:

	LIBS += -lXxf86vm -L/user/lib/x86_64-linux-gnu/

	Secondly, if the ordering matters, you would need to use LIBS for glfw3, too, something like this:

	LIBS += -lglfw3 -lXxf86vm -L/user/lib/x86_64-linux-gnu/

	Do not forget to assign the glfw3 path as well if needed. That is depending on your setup. You could probably try to swap the order of your current PKGCONFIG and LIBS statements, but it is not that much future proof if you move code around. Also, if you can share the path between the two libraries, I would not personally use PKGCONFIG, just LIBS.

////////////////////////////////////////////////////////////////

Description	Resource	Path	Location	Type
/usr/local/lib/libglfw3.a(glx_context.c.o): undefined reference to symbol 'pthread_key_delete@@GLIBC_2.2.5'	Create_Window		 	C/C++ Problem

	add -pthread or thread

////////////////////////////////////////////////////////////////

Description	Resource	Path	Location	Type
undefined reference to `XIQueryVersion'	Create_Window		line 0	C/C++ Problem
   and so on ....


	I was misled into believing that I was linking everything necessary because of the output of

	pkg-config --libs --cflags --print-requires glfw3 

	which was

	-I/usr/local/include  -L/usr/local/lib -lglfw3  

	The --print-requires flag was having no impact at all on the output, which seemed odd. I searched and printed the corresponding .pc file.

	sudo find / | grep "glfw3\.pc"
	cat /usr/local/lib/pkgconfig/glfw3.pc 

	There I found this.

	Requires.private:  x11 xrandr xi xxf86vm gl

	Which indicates which libraries are required for static linking. I added their correponding flags to CMake and it worked. My mistake was that I missed the --print-requires-private flag when executing pkg-config.

	I hope this helps someone save some time.

I am under Ubuntu 14.04 and had to add theses libraries: X11 Xrandr Xi Xxf86vm Xcursor Xinerama !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


////////////////////////////////////////////////////////////////////




