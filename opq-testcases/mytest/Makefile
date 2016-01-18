BAPDIR=../..
TRACENAME=28550-out.bpt
ILNAME=mytest1.opq.il

trace:
	$(BAPDIR)/pin/pin -t $(BAPDIR)/pintraces/obj-ia32/gentrace.so -taint_stdin -- ./mytest1

con:
	$(BAPDIR)/utils/iltrans -trace $(TRACENAME) -trace-concrete -pp-ast $(TRACENAME).con.il

filter:
	$(BAPDIR)/opq-testcases/filter1.pl < $(TRACENAME).con.il | $(BAPDIR)/opq-testcases/filter2.pl > $(ILNAME)

pre_process:
	$(BAPDIR)/utils/pre_process.pl $(ILNAME)

clean:
	rm -f *.stp *.bpt *.il pintool.log *~
