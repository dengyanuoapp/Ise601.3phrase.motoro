
LM_LICENSE_FILE?=56789@127.0.0.1


other_para01:=
#other_para01:= -LDFLAGS -Wl,--no-as-needed 
#other_para01:= -cc gcc44 -cpp g++44
ifneq (,$(wildcard /usr/bin/gcc-4.8))
other_para01+= -cc gcc-4.8 -cpp g++-4.8     
# -CC -no-pie 
endif
# -CFLAGS -no-pie

#VCS_64=
VCS_64=-full64

#VCS_ARCH_OVERRIDE=VCS_ARCH_OVERRIDE=linux
#VCS_ARCH_OVERRIDE=VCS_ARCH_OVERRIDE=linux64
VCS_ARCH_OVERRIDE=

#VCS_HOME=/e/eda2321/VCS_2018.09
VCS_HOME=/e/eda2321/VCS_2016.06

#PATH:=PATH=$(VCS_HOME)/linux/bin:$(PATH):$(VCS_HOME)/bin
PATH:=PATH=$(VCS_HOME)/linux64/bin:$(PATH):$(VCS_HOME)/bin


export CMDline:=$(VCS_ARCH_OVERRIDE)                            \
	LM_LICENSE_FILE=$(LM_LICENSE_FILE)          \
	VCS_HOME=$(VCS_HOME) 			            \
	\
	$(PATH)                                     \
	\
	vcs  		                \
	\
	$(VCS_64)                                   \
	$(other_para01)                             \
	\
	ttt/Counter_tb.v                            \
	ttt/Counter.v 

define show_help_text

c            -->>>    clean 
rvs          -->>>    run_verilog_sim 
bvs          -->>>    build_verilog_sim 
aaa          -->>>    $(aaa)

endef
export show_help_text

all:
	@echo "$${show_help_text}"

aaa:=c rvs bvs          
aaa:$(aaa)

m: Makefile
	vim $<

c clean:
	rm -fr                                                      \
		simv                                                    \
		simv.daidir/                                            \
		csrc/                                                   \
		stack.info.*/                                           \
		ucli.key                               

bvs build_verilog_sim:
	$(CMDline) || (echo "${CMDline}" ; exit 33 )

rvs run_verilog_sim:
	$(CMDline) && ./simv || echo "${CMDline}"

