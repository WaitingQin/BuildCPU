webtalk_init -webtalk_dir /headless/project_test/project_test.sim/sim_1/behav/xsim/xsim.dir/count10_tb_behav/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Tue Nov  1 13:56:07 2022" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2019.2 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "2708876" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "61ae37a4-cc15-4f23-8842-4b388aed6ebb" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "b5339eb0aa9f400faa5bdb393582ca00" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "31" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Ubuntu" -context "user_environment"
webtalk_add_data -client project -key os_release -value "Ubuntu 18.04.1 LTS" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Xeon(R) Gold 6226R CPU @ 2.90GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "1300.000 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "2" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "270.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key File_Counter -value "3" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key Command -value "xelab" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key Vhdl2008 -value "false" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key GenDLL -value "false" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key SDFModeling -value "false" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key HWCosim -value "false" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key DPI_Used -value "false" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key Debug -value "typical" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key Simulation_Image_Code -value "18 KB" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Image_Data -value "3 KB" -context "xsim\\usage"
webtalk_add_data -client xsim -key Total_Nets -value "0" -context "xsim\\usage"
webtalk_add_data -client xsim -key Total_Processes -value "20" -context "xsim\\usage"
webtalk_add_data -client xsim -key Total_Instances -value "3" -context "xsim\\usage"
webtalk_add_data -client xsim -key Xilinx_HDL_Libraries_Used -value "secureip unimacro_ver unisims_ver " -context "xsim\\usage"
webtalk_add_data -client xsim -key Compiler_Time -value "1.04_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Compiler_Memory -value "212416_KB" -context "xsim\\usage"
webtalk_transmit -clientid 560735972 -regid "" -xml /headless/project_test/project_test.sim/sim_1/behav/xsim/xsim.dir/count10_tb_behav/webtalk/usage_statistics_ext_xsim.xml -html /headless/project_test/project_test.sim/sim_1/behav/xsim/xsim.dir/count10_tb_behav/webtalk/usage_statistics_ext_xsim.html -wdm /headless/project_test/project_test.sim/sim_1/behav/xsim/xsim.dir/count10_tb_behav/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate
