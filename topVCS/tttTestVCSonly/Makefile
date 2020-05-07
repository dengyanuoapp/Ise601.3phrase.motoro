
LM_LICENSE_FILE?=56789@127.0.0.1

all:
	rm -fr                                                      \
		simv/                                                   \
		simv.daidir/                                            \
		csrc/                                                   \
		stack.info.*/                                           \
		ucli.key                               
	VCS_ARCH_OVERRIDE=linux \
					  LM_LICENSE_FILE=${LM_LICENSE_FILE}        \
					  VCS_HOME=/e/eda2321/VCS_2018.09 			\
					  \
					  /e/eda2321/VCS_2018.09/bin/vcs  		    \
					  \
					  -full64                                   \
					  \
					  ttt/Counter_tb.v                          \
					  ttt/Counter.v 
	./simv
