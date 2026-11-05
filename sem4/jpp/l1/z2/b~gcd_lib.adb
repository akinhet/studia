pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (gcdlibmain, Spec_File_Name => "b~gcd_lib.ads");
pragma Source_File_Name (gcdlibmain, Body_File_Name => "b~gcd_lib.adb");
pragma Suppress (Overflow_Check);

package body gcdlibmain is

   E076 : Short_Integer; pragma Import (Ada, E076, "system__os_lib_E");
   E010 : Short_Integer; pragma Import (Ada, E010, "ada__exceptions_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "system__soft_links_E");
   E026 : Short_Integer; pragma Import (Ada, E026, "system__exception_table_E");
   E042 : Short_Integer; pragma Import (Ada, E042, "ada__containers_E");
   E071 : Short_Integer; pragma Import (Ada, E071, "ada__io_exceptions_E");
   E033 : Short_Integer; pragma Import (Ada, E033, "ada__numerics_E");
   E056 : Short_Integer; pragma Import (Ada, E056, "ada__strings_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "ada__strings__maps_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "ada__strings__maps__constants_E");
   E046 : Short_Integer; pragma Import (Ada, E046, "interfaces__c_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "system__exceptions_E");
   E087 : Short_Integer; pragma Import (Ada, E087, "system__object_reader_E");
   E051 : Short_Integer; pragma Import (Ada, E051, "system__dwarf_lines_E");
   E022 : Short_Integer; pragma Import (Ada, E022, "system__soft_links__initialize_E");
   E041 : Short_Integer; pragma Import (Ada, E041, "system__traceback__symbolic_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure gcdlibfinal is

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      null;
   end gcdlibfinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure gcdlibinit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");
      Interrupts_Default_To_System : Integer;
      pragma Import (C, Interrupts_Default_To_System, "__gl_interrupts_default_to_system");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;

      gcdlibmain'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      if E010 = 0 then
         Ada.Exceptions'Elab_Spec;
      end if;
      if E015 = 0 then
         System.Soft_Links'Elab_Spec;
      end if;
      if E026 = 0 then
         System.Exception_Table'Elab_Body;
      end if;
      E026 := E026 + 1;
      if E042 = 0 then
         Ada.Containers'Elab_Spec;
      end if;
      E042 := E042 + 1;
      if E071 = 0 then
         Ada.Io_Exceptions'Elab_Spec;
      end if;
      E071 := E071 + 1;
      if E033 = 0 then
         Ada.Numerics'Elab_Spec;
      end if;
      E033 := E033 + 1;
      if E056 = 0 then
         Ada.Strings'Elab_Spec;
      end if;
      E056 := E056 + 1;
      if E058 = 0 then
         Ada.Strings.Maps'Elab_Spec;
      end if;
      E058 := E058 + 1;
      if E061 = 0 then
         Ada.Strings.Maps.Constants'Elab_Spec;
      end if;
      E061 := E061 + 1;
      if E046 = 0 then
         Interfaces.C'Elab_Spec;
      end if;
      E046 := E046 + 1;
      if E027 = 0 then
         System.Exceptions'Elab_Spec;
      end if;
      E027 := E027 + 1;
      if E087 = 0 then
         System.Object_Reader'Elab_Spec;
      end if;
      E087 := E087 + 1;
      if E051 = 0 then
         System.Dwarf_Lines'Elab_Spec;
      end if;
      E051 := E051 + 1;
      if E076 = 0 then
         System.Os_Lib'Elab_Body;
      end if;
      E076 := E076 + 1;
      if E022 = 0 then
         System.Soft_Links.Initialize'Elab_Body;
      end if;
      E022 := E022 + 1;
      E015 := E015 + 1;
      if E041 = 0 then
         System.Traceback.Symbolic'Elab_Body;
      end if;
      E041 := E041 + 1;
      E010 := E010 + 1;
   end gcdlibinit;

--  BEGIN Object file/option list
   --   ./gcd_lib.o
   --   -L./
   --   -L/usr/lib/gcc/x86_64-pc-linux-gnu/15.2.1/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end gcdlibmain;
