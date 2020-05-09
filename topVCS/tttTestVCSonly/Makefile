
LM_LICENSE_FILE?=LM_LICENSE_FILE=56789@127.0.0.1

VCS_HOME=/e/eda2321/VCS_2018.09
#VCS_HOME=/e/eda2321/VCS_2016.06
VCS_ARCH_OVERRIDE=

DC_HOME=/e/eda2331/DC_201603
PATHdc:=PATH=$(DC_HOME)/bin:$(DC_HOME)/linux64/bin:$(PATH)

#other_para01:= -LDFLAGS -Wl,--no-as-needed 
#other_para01:= -cc gcc44 -cpp g++44
# -CFLAGS -no-pie

other_para01:=
ifneq (,$(wildcard /usr/bin/gcc-4.8))
#other_para01+= -cc gcc-4.8 -cpp g++-4.8     
endif

USE64=1
ifeq (,$(USE64))
VCS_64=
#VCS_ARCH_OVERRIDE=VCS_ARCH_OVERRIDE=linux64
PATHvcs:=PATH=$(VCS_HOME)/linux/bin:$(PATH):$(VCS_HOME)/bin
else
VCS_64=-full64
#VCS_ARCH_OVERRIDE=VCS_ARCH_OVERRIDE=linux
PATHvcs:=PATH=$(VCS_HOME)/linux64/bin:$(PATH):$(VCS_HOME)/bin
endif





export CMDline:=$(VCS_ARCH_OVERRIDE)            \
	$(LM_LICENSE_FILE)                          \
	VCS_HOME=$(VCS_HOME) 			            \
	\
	$(PATHvcs)                                  \
	\
	vcs  		                                \
	\
	$(VCS_64)                                   \
	$(other_para01)                             \
	\
	ttt/Counter_tb.v                            \
	ttt/Counter.v 

define show_help_text

c            -->>>    clean 
bvs          -->>>    build_verilog_sim 
rvs          -->>>    run_verilog_sim 
aaa          -->>>    $(aaa)

dcdc         -->>>    $(dcdc)

endef
export show_help_text

vim:=vim -i /tmp/_viminfo.$(USER)
all:
	@echo "$${show_help_text}"

aaa:=c bvs rvs
aaa:$(aaa)

m: Makefile
	@echo
	$(vim) $<
	@echo

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
	./simv 

dcdc := run_dc_shell
dcdc_CMD := \
	$(LM_LICENSE_FILE)                          \
	$(PATHdc) \
	$(DC_HOME)/bin/design_vision-xg
# dc_shell-t
# dc_shell
# dc_shell-xg-t
# design_vision-xg
# design_vision

dcdc :
	$(dcdc_CMD)
