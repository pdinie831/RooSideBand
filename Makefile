#object_files (testEffi.o)
OBJECTS := $(wildcard *.o)

#root_stuff (root libraries and needed root options)
ROOTLIBS := $(shell root-config --glibs)
ROOTFLAGS := $(shell root-config --cflags --libs) -lRooFit -lRooFitCore
ROOTCINT := $(shell which rootcint)

#exe_files
EXECUTABLE  := testSideband
#EXMAKEHIST  := testEffi3DB0-2016-makeHisto
CLASS       := RooBernsteinSideband
CLASSDICT   := $(CLASS)Dictionary.cxx
CLASSCB       := RooDoubleCBFast
CLASSCBDICT   := $(CLASSCB)Dictionary.cxx

#compiling options
DEBUGFLAGS := -O3 -Wall -std=c++11
CXXFLAGS := $(DEBUGFLAGS) 

#compile class
LIBS := $(CLASS).cxx  $(CLASSDICT) $(CLASSCB).cxx  $(CLASSCBDICT)

	
all: $(CLASSDICT)   $(CLASSCBDICT) $(EXECUTABLE) $(EXMAKEHIST)

dict: $(CLASSDICT)   $(CLASSCBDICT)

hist: $(EXMAKEHIST)

$(CLASSDICT): $(CLASS).h $(CLASS)LinkDef.h
	@echo "Generating dictionary $@ using rootcint ..."
	$(ROOTCINT) -f $@ -c $^

$(CLASSCBDICT): $(CLASSCB).h $(CLASSCB)LinkDef.h
	@echo "Generating dictionary $@ using rootcint ..."
	$(ROOTCINT) -f $@ -c $^

$(EXECUTABLE): $(EXECUTABLE).cc 
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIBS) $(ROOTLIBS) $(ROOTFLAGS) -I.

#$(EXMAKEHIST): $(EXMAKEHIST).cc 
#	$(CXX) $(CXXFLAGS)  -o $@  $^ $(ROOTLIBS) $(ROOTFLAGS) -I.



#cleaning options
.PHONY: clean cleanall
clean:
	rm -f $(OBJECTS) && rm -f $(EXECUTABLE) $(EXMAKEHIST) $(CLASSDICT)
cleanhist:
	rm -f  $(EXMAKEHIST)

