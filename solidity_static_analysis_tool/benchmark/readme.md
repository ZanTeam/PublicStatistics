# Solidity Static Analysis Tool
ZAN (https://zan.top/home) has released the benchmark of its solidity static analysis tool, and the contracts source code can be seen in the ```contracts``` directory. The specific location of the risk point is marked in detail in the contract. What's more, we list the specific descriptions and suggestions of each rule in detail below, and count the number of risk points in corresponding contracts, which can be viewed in the table ```rule_risk-point-num.csv```.
# Rules Description
We divide the rules into two categories: Code Security and Optimization Suggestion. Code Security includes general vulnerabilities and compiler bugs, and Optimization Suggestion includes code conventions and gas optimization. A detailed description of the rules is as follows.
## Code Security
### Reentrancy_Issue
#### Properties
- name : Reentrancy
- category : Code Security
- severity : High
#### Description
The external call is executed before state variables update, so the external contract can call back to this one and make Reentry attack.
#### Recommendation
Use the checks-effects-interactions pattern to update state variables and call external contracts.
### IntegerOverflow_Issue
#### Properties
- name : Integer Overflow/Underflow
- category : Code Security
- severity : High
#### Description
An overflow/underflow may happen when an arithmetic operation reaches the maximum or minimum size of a type.
#### Recommendation
Contracts using compiler versions below 0.8.0 are recommended to use the safemath library for arithmetic operations.
### DelegateCall_Issue_Arbitrary
#### Properties
- name : Arbitrary DelegateCall
- category : Code Security
- severity : High
#### Description
If the delegatecall address is externally controllable, the user can perform arbitrary actions through the delegatecall to cause attacks.
#### Recommendation
Call address for delegate call should be fixed or verified.
### DelegateCall_Issue_Privilege
#### Properties
- name : Privileged User DelegateCall
- category : Code Security
- severity : Low
#### Description
If the delegatecall address is controlled by privileged user, the user may perform arbitrary actions through the delegatecall to cause attacks.
#### Recommendation
Call address for delegate call should be fixed or verified.
### FrozenMoney_Issue
#### Properties
- name : Freeze Money
- category : Code Security
- severity : High
#### Description
There is at least one payable function in the contract, but no transfer function(like send, transfer, call...) exists, which will cause Ether to be locked in the contract.
#### Recommendation
When there is a payable function in the contract, a function with a transfer function needs to be provided.
### ReturnStopInAssembly_Issue_ModifierInterrupt
#### Properties
- name : return/stop Statements in Assembly Interrupt Modifier Execution
- category : Code Security
- severity : High
#### Description
The return or stop statement in the assembly will directly terminate the execution of the program, so that the statement after the placeholder _ in the modifier will not be executed, resulting in severe problems like reentrant lock deadlock.
#### Recommendation
It is recommended to remove the anti-reentrancy modifier of the function, or remove the return or stop statement in the assembly.
### ExceedAuth_Issue
#### Properties
- name : Arbitrary External Call
- category : Code Security
- severity : High
#### Description
If the address of an external call or transfer can be controlled by the user, the user can perform arbitrary actions to cause the attack to occur.
#### Recommendation
Ether transfer or sensitive external call with call address set from input parameter should be carefully authenticated.
### RTLO_Issue
#### Properties
- name : Right-To-Left-Override Control Character (U+202E)
- category : Code Security
- severity : High
#### Description
An attacker can manipulate the logic of the contract by using a right-to-left-override character (U+202E).
#### Recommendation
Special control characters must not be allowed.
### Unauthenticated_Issue
#### Properties
- name : Unauthenticated Storage Access
- category : Code Security
- severity : Medium
#### Description
Modification to state variable(s) is not restricted by authenticating msg.sender.
#### Recommendation
Authenticate msg.sender when crucial state variables will be updated. e.g. require(msg.sender == ...).
### WeakRand_Issue
#### Properties
- name : Weak Sources of Randomness
- category : Code Security
- severity : Medium
#### Description
You are likely only to use chain attributes(e.g. block.timestamp, blockhash) as random seed which is insecure, as miner/consensus node could intentionally control these values.
#### Recommendation
Don't purely use chain attributes to generate random, proper oracle is highly recommended.
### TxOrigin_Issue
#### Properties
- name : Usage of tx.origin
- category : Code Security
- severity : Medium
#### Description
There may be phishing attacks using tx.origin for authentication.
#### Recommendation
Don't use tx.origin for authorization.
### CallConfirm_Issue
#### Properties
- name : Unchecked Call Return Value
- category : Code Security
- severity : Medium
#### Description
Eth send or low level call could fail. So make sure to always check the call's return value.
#### Recommendation
It is recommended to check the return value of the external call or ETH transfer. And ETH transfer is recommended to use function transfer.
### InheritanceAmbiguity_Issue
#### Properties
- name : Incorrect Inheritance Order
- category : Code Security
- severity : Medium
#### Description
In multiple inheritance scenario, if C inherits A and B, for C, the same members or methods exist in A and B are prone to ambiguity.
#### Recommendation
Prohibit the existence of diamond inheritance. When inheriting from multiple base classes, the members and functions of the base classes cannot have the same name.
### ThisBalance_Issue
#### Properties
- name : Unexpected Ether Balance
- category : Code Security
- severity : Medium
#### Description
Strict checks on the balance of the account may cause the contract to run abnormally, because the change of the balance of the account may be affected by various factors. For example, the selfdestruct method in a contract allows sending arbitrary Ether to another contract without triggering the fallback function of another contract.
#### Recommendation
Avoid strict equality checks on contract account balances.
### VarTypeDeduction_Issue
#### Properties
- name : VarType Deduction
- category : Code Security
- severity : Medium
#### Description
When an integer variable is specified as var type, the compiler infers the smallest possible type (uint8), which may cause overflow in subsequent operations.
#### Recommendation
Use certain types to define variables when coding.
### ControlledArrayLength_Issue
#### Properties
- name : Externally Controlled Array Length
- category : Code Security
- severity : Low
#### Description
If the dynamic array length is externally controlled, there may be a risk of denial of service.
#### Recommendation
Dynamic array length should not be controlled externally.
### UninitializedVariable_Issue
#### Properties
- name : Uninitialized Variables
- category : Code Security
- severity : Low
#### Description
Variables that are not initialized after definition are used in the contract.
#### Recommendation
Initialize the variable when it is defined.
### ShadowVariable_Issue_State
#### Properties
- name : Shadowed by State Variables
- category : Code Security
- severity : Medium
#### Description
Variable shadowing occurs when a state variable declared within a contract scope has the same name as a state variable declared in an outer scope. Allowing for ambiguous naming of variables will lead to imperceptible logic bugs.
#### Recommendation
Review variable layouts for your contract carefully and remove any ambiguities.
### ShadowBuiltinAndKeywords_Issue_Builtin
#### Properties
- name : Duplicate Naming with Builtin Symbols
- category : Code Security
- severity : Low
#### Description
There are many builtin symbols in solidity. When declaring functions, events and variables, if they have the same name as the builtin function, it will cause logical misjudgment or compilation problems.
#### Recommendation
It is recommended to choose a different function, event or variable name to avoid the same name as the builtin symbols.
### DivBeforeMul_Issue
#### Properties
- name : Division Before Multiplication
- category : Code Security
- severity : Low
#### Description
Solidity operates only with integers. Thus, if the division is done before the multiplication, the rounding errors can increase dramatically.
#### Recommendation
It is recommended to perform multiplication before division to avoid precision loss.
### FunctionCallWithinContractIncorrect_Issue_NonReentrancy
#### Properties
- name : NonReentrant Function Calls NonReentrant Function
- category : Code Security
- severity : High
#### Description
In a contract, function A with reentrancy protection modifier calls function B with reentrancy protection modifier, which will cause the logic of function B to fail to execute.
#### Recommendation
It is recommended to implement the part of function B called by function A as an internal function C without reentrancy protection. Thus both A and B can call C to implement the previous logic.
### DelegateCallInLoop_Issue
#### Properties
- name : delegatecall used inside a loop
- category : Code Security
- severity : Low
#### Description
A payable function calls another function through delegatecall in a loop. If the called function is a payable function and msg.value is used, some unexpected behaviors may occur.
#### Recommendation
It is recommended to carefully check the function called by delegatecall to ensure that it is not a payable function or does not use msg.value.
### MsgValueInLoop_Issue
#### Properties
- name : msg.value used inside a loop
- category : Code Security
- severity : Low
#### Description
A payable function uses msg.value in a loop, which may have some unexpected behavior.
#### Recommendation
It is recommended to check whether the function uses msg.value in the loop according to the expected logic. If it is logical, it is recommended to use a local variable to save the value of msg.value before the execution of the for loop, and then use the local variable in the for loop, which can save a lot of gas.
### IncorrectEIP712SignatureEncode_Issue
#### Properties
- name : Not Follow the EIP-712 Signature Encoding Specification
- category : Code Security
- severity : Medium
#### Description
According to EIP-712 (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md), the personal sign should be encoded as: encode(b : 𝔹⁸ⁿ) = "\x19Ethereum Signed Message:\n" ‖ len(b) ‖ b, where len(b) is the ascii-decimal encoding of the number of bytes in b. Please check if len(b) is the length of b.
#### Recommendation
It is recommended to strictly follow the specification of EIP-712 (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md) to ensure that the length of the signature message is equal to the specified length.
### IncorrectShiftInAssembly_Issue
#### Properties
- name : Incorrect Shift in Assembly
- category : Code Security
- severity : Medium
#### Description
When using shr, shl, sar operations in assembly, the first parameter represents the number of digits to shift, and the second parameter is the value to be shifted. Be careful not to reverse the parameters. Similarly, opcodes signextend and byte also need to pay attention to the order of parameters.
#### Recommendation
It is recommended to check the parameter order and swap the parameter if it does not match the logic.
### DoWhileContinue_Issue
#### Properties
- name : Usage of Continue in the DO-WHILE Loop
- category : Code Security
- severity : High
#### Description
Prior to version 0.5.0, Solidity compiler handles continue inside do-while loop incorrectly for which it ignores while condition.
#### Recommendation
Do not use continue in the do-while loop when using compiler whose version is below 0.5.0.
### OverridePrivateFunctionInParentContract_Issue
#### Properties
- name : Private Function Can Be Overridden
- category : Code Security
- severity : High
#### Description
From compiler version 0.3.0 to 0.5.16, while private methods of base contracts are not visible and cannot be called directly from the derived contract, it is still possible to declare a function of the same name and type and thus change the behaviour of the base contract's function.
#### Recommendation
From compiler version 0.3.0 to 0.5.16, when defining functions in the sub-contract, it is necessary not to override the private functions in the base contract.
### DelegateCallReturnValue_Issue
#### Properties
- name : Usage of Return Value of Delegatecall
- category : Code Security
- severity : Informational
#### Description
When using compiler of version between 0.3.0 and 0.4.14, the low-level .delegatecall() does not return the execution outcome, but converts the value returned by the functioned called to a boolean instead.
#### Recommendation
When using compiler of version between 0.3.0 and 0.4.14, do not use the return value of delegatecall.
### EventStructWrongData_Issue
#### Properties
- name : Using Structs in Events
- category : Code Security
- severity : Informational
#### Description
When using compiler of version between 0.4.17 and 0.4.24, using structs in events logged wrong data.
#### Recommendation
When using compiler of version between 0.4.17 and 0.4.24, do not use struct in event.
### IncorrectEventSignature_Issue
#### Properties
- name : Incorrect Event Signature In Libraries
- category : Code Security
- severity : Informational
#### Description
When using compiler of version between 0.4.17 and 0.4.24, contract types used in events in libraries cause an incorrect event signature hash.
#### Recommendation
When using compiler of version between 0.3.0 and 0.5.8, do not use contract type in event.
### SkipEmptyStringLiteral_Issue
#### Properties
- name : Skip Empty String Literal
- category : Code Security
- severity : High
#### Description
When using compiler of version below 0.4.12, if "" is used in a function call, the following function arguments will not be correctly passed to the function.
#### Recommendation
When using compiler of version below 0.4.12, do not use ""(null string) in a function call.
### ExpExponentCleanup_Issue
#### Properties
- name : Exponent of Type Shorter Than 256 Bits
- category : Code Security
- severity : Informational
#### Description
When using compiler of version below 0.4.25, using the ** operator with an exponent of type shorter than 256 bits can result in unexpected values.
#### Recommendation
When using compiler of version below 0.4.25, do not use the ** operator with an exponent of type shorter than 256 bits can result in unexpected values.
### NestedArrayFunctionCall_Issue
#### Properties
- name : Nested Array Function Call Decoder
- category : Code Security
- severity : Informational
#### Description
When using compiler of version below 0.4.22, calling functions that return multi-dimensional fixed-size arrays can result in memory corruption.
#### Recommendation
When using compiler of version below 0.4.22, do not calling functions that return multi-dimensional fixed-size arrays.
### DynamicConstructorArgumentsClippedABIV2_Issue
#### Properties
- name : Dynamic Constructor Arguments
- category : Code Security
- severity : High
#### Description
When using compiler of version between 0.4.16 and 0.5.9, the parameters in the constructor are forbidden to use dynamic arrays. If the parameters are structures, the structure members are not allowed to be dynamic arrays, otherwise the contract constructor will be reverted or decoded as invalid data.
#### Recommendation
When using compiler of version between 0.4.16 and 0.5.9, the parameters in the constructor are forbidden to use dynamic arrays. If the parameters are structures, the structure members are not allowed to be dynamic arrays.
### ABIEncoderV2StorageArrayWithMultiSlotElement_Issue
#### Properties
- name : ABIEncoderV2 Storage Array With MultiSlot Element
- category : Code Security
- severity : Medium
#### Description
When using compiler of version between 0.4.10 and 0.5.10, it is forbidden to send structure arrays or static multi-dimensional arrays (two-dimensional and above) directly to external calls/events/abi.encode for use, and data cannot be read correctly.
#### Recommendation
When using compiler of version between 0.4.10 and 0.5.10, it is forbidden to send structure arrays or static multi-dimensional arrays (two-dimensional and above) directly to external calls/events/abi.encode for use.
### SignedArrayStorageCopy_Issue
#### Properties
- name : Signed Array Storage
- category : Code Security
- severity : Medium
#### Description
Using compiler of version between 0.4.7 and 0.5.9, signed integer array allocation should not contain negative numbers, otherwise it will cause errors.
#### Recommendation
Using compiler of version between 0.4.7 and 0.5.9, signed integer array allocation should not contain negative numbers, assignment should be done in such a way as a[0] = -1.
### MultipleConstructors_Issue
#### Properties
- name : Multiple Constructors
- category : Code Security
- severity : Medium
#### Description
The compiler of version 0.4.22 allows constructors declared with the constructor keyword and contract names to exist at the same time, and the constructors defined later will be invalid.
#### Recommendation
When using the compiler of version 0.4.22, it is recommended to use only one form of the constructor.
### UninitializedFunctionPointerInConstructor_Issue
#### Properties
- name : Uninitialized Function Pointer in Constructor
- category : Code Security
- severity : Low
#### Description
When using compiler of version between 0.4.5 and 0.4.25 or between 0.5.0 and 0.5.7, calling uninitialized internal function pointers created in the constructor does not always revert and can cause unexpected behaviour. For specific reasons, please refer to the official document description (https://docs.soliditylang.org/en/v0.8.17/bugs.html).
#### Recommendation
When using compiler of version between 0.4.5 and 0.4.25 or between 0.5.0 and 0.5.7, it is recommended must to initialize internal function pointers created in the constructor.
### NestedStructInPublicMap_Issue
#### Properties
- name : Nested Structs in Public Mapping
- category : Code Security
- severity : Low
#### Description
In the compiler of version before 0.5.0, if there is a nested struct in the mapping whose visibility is public, but the contract does not explicitly use pragma experimental ABIEncoderV2, the compiler will not report an error, but it will cause the failure of reading the mapping variable by default getter function.
#### Recommendation
In compiler of version before 0.5.0, if there are nested structs in mapping whose visibility is public, it is recommended not to use public visibility or explicitly use pragma experimental ABIEncoderV2.
## Optimization Suggestion
### ShadowVariable_Issue_Local
#### Properties
- name : Shadowed by Local Variables
- category : Optimization Suggestion
- severity : Low
#### Description
Variable shadowing occurs when a local variable declared within a function has the same name as a state variable declared in an outer scope. Allowing for ambiguous naming of variables will lead to imperceptible logic bugs.
#### Recommendation
Review variable layouts for your contract carefully and remove any ambiguities.
### ShadowBuiltinAndKeywords_Issue_Keywords
#### Properties
- name : Duplicate Naming with Reserved Keywords
- category : Optimization Suggestion
- severity : Informational
#### Description
Some keywords are reserved in solidity for subsequent use. When declaring functions, events and variables, if they have the same name as the reserved keywords, it may cause logical misjudgment or compilation problems in the future.
#### Recommendation
It is recommended to choose a different function, event or variable name to avoid the same name as the reserved keywords.
### ThisCall_Issue
#### Properties
- name : Unchecked this.call
- category : Optimization Suggestion
- severity : Informational
#### Description
Calling functions through this.call(...) may have the risk of bypassing permission control.
#### Recommendation
It is recommended to check whether the called function is at risk of bypassing permission control.
### ERC20_Standard_Issue_Func
#### Properties
- name : ERC20 | Incorrect Function Definition
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC20 - The function definition does not conform to the ERC20 standard.
#### Recommendation
ERC20 - The correct definition of the function should refer to the link: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md.
### ERC20_Standard_Issue_Event
#### Properties
- name : ERC20 | Incorrect Event Definition
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC20 - The event definition does not conform to the ERC20 standard.
#### Recommendation
ERC20 - The correct definition of the event should refer to the link: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md.
### ERC20_Standard_Issue_AlwaysReturnFalse
#### Properties
- name : ERC20 | Always Return False
- category : Optimization Suggestion
- severity : Informational
#### Description
This function does not return true, so the return value of this function is always false.
#### Recommendation
ERC20 - When function returns a variable of bool type, return true should exist in the function.
### ERC20_Standard_Issue_ShouldTransfer
#### Properties
- name : ERC20 | Missing Emit Events in transfer()/transferFrom()
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC20 - Function does not emit Transfer event.
#### Recommendation
ERC20 - The ERC20 standard claims that the transfer/transferFrom function should emit the Transfer event.
### ERC20_Standard_Issue_FakeDeposit
#### Properties
- name : ERC20 | Fake Deposit
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC20 - The contract uses if/else for conditional judgment. If the condition is not met, it will directly return false, and there is a possibility of fake deposit.
#### Recommendation
ERC20 - When the conditions are not met, the exception should be throw directly, or you can use the if/else + revert/throw recommended by EIP20 to throw the exception.
### ERC20_Standard_Issue_ShouldApproval
#### Properties
- name : ERC20 | Missing Events Emitting in approve()
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC20 - The approve function do not emit Approval event.
#### Recommendation
ERC20 - The ERC20 standard claims that the approve function should emit the Approval event.
### ERC721_Standard_Issue_Func
#### Properties
- name : ERC721 | Incorrect Function Definition
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC721 - The function definition does not conform to the ERC721 standard.
#### Recommendation
ERC721 - The correct definition of the function should refer to the link: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
### ERC721_Standard_Issue_Event
#### Properties
- name : ERC721 | Incorrect Event Definition
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC721 - The event definition does not conform to the ERC721 standard.
#### Recommendation
ERC721 - The correct definition of the event should refer to the link: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
### ERC777_Standard_Issue_Func
#### Properties
- name : ERC777 | Incorrect Function Definition
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC777 - The function definition does not conform to the ERC777 standard.
#### Recommendation
ERC777 - The correct definition of the function should refer to the link: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-777.md.
### ERC777_Standard_Issue_Event
#### Properties
- name : ERC777 | Incorrect Event Definition
- category : Optimization Suggestion
- severity : Informational
#### Description
ERC777 - The event definition does not conform to the ERC777 standard.
#### Recommendation
ERC777 - The correct definition of the event should refer to the link: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-777.md.
### SolcVersion_Issue
#### Properties
- name : Floating Pragma
- category : Optimization Suggestion
- severity : Informational
#### Description
Contracts should be deployed with the fixed compiler version that they have been tested thoroughly. Pinning the compiler version helps ensure that contracts are not compiled by untested compiler versions.
#### Recommendation
Use a fixed compiler version, and consider whether the bugs in the selected compiler version (https://github.com/ethereum/solidity/releases) will affect the contract.
### LOC_Issue
#### Properties
- name : Function LOC Too Long
- category : Optimization Suggestion
- severity : Informational
#### Description
Lines of code in a single function should not more than 200.
#### Recommendation
It is recommended to refactor the function to reduce the number of lines of the function. For example, extract part of the logic into another function based on the principle that one function has one feature.
### CallInsteadOfSendOrTransfer_Issue
#### Properties
- name : Prefer .call() To send()/transfer()
- category : Optimization Suggestion
- severity : Informational
#### Description
The send or transfer function has a limit of 2300 gas.
#### Recommendation
It is recommended to use .call instead of send or transfer.
### NoneInfomationRevert_Issue
#### Properties
- name : Lack of Error Message
- category : Optimization Suggestion
- severity : Informational
#### Description
Use empty string as parameter while invoking function Revert() or Require().
#### Recommendation
Use string with specific information as parameter while invoking function Revert() or Require().
### UserDefinedReferenceVarLocation_Issue
#### Properties
- name : User Defined Reference Variables Declared Without Storage Location
- category : Optimization Suggestion
- severity : Informational
#### Description
The storage location is not specified when the user defined reference variable in the contract using the compiler of version below 0.5.0 is declared.
#### Recommendation
It is recommended to specify the storage location when declaring the user defined reference variable in the contract, such as memory, storage, etc.
### Outdated_SolcVersion_Issue
#### Properties
- name : Usage of Outdated Compiler
- category : Optimization Suggestion
- severity : Informational
#### Description
The outdated compiler version (below solidity 0.8.0) is used in the contract, and there may be some security vulnerabilities.
#### Recommendation
It is recommended to use a compiler version above solidity 0.8.0.
### Import_Issue
#### Properties
- name : Import Issue
- category : Optimization Suggestion
- severity : Informational
#### Description
In the contract, the file is only imported by the file name, which may cause the actual imported file to be different from the target file.
#### Recommendation
It is recommended to use ./+filename to import files.
### FunctionVisibility_Issue
#### Properties
- name : Function Visibility Specifiers Missing
- category : Optimization Suggestion
- severity : Informational
#### Description
The function definition in the contract using the compiler of version below 0.5.0 does not have clear visibility.
#### Recommendation
Function definitions in contracts using compiler of version below 0.5.0 must have explicit visibility.
### FunctionVisibility_Issue_FallbackAndInterface
#### Properties
- name : Incorrect Visibility of Fallback Function/Interface Function
- category : Optimization Suggestion
- severity : Informational
#### Description
In contracts using compiler of version below 0.5.0, the visibility of the fallback function and interface function is not declared as external.
#### Recommendation
In contracts using compiler of version below 0.5.0, the visibility of fallback functions and interface functions should be declared as external.
### FunctionVisibility_Issue_Constructor
#### Properties
- name : Incorrect Visibility of Constructor
- category : Optimization Suggestion
- severity : Informational
#### Description
Before the compiler version 0.7.0, the visibility of the constructor is not declared as public or internal. In compiler version 0.7.0 and above, the constructor does not need to declare visibility.
#### Recommendation
Prior to compiler version 0.7.0, constructor had to be declared public or internal. In compiler version 0.7.0 and above, the constructor does not need to declare visibility.
### DelegateCallInsteadOfCallCode_Issue
#### Properties
- name : Prefer delegatecall() To callcode()
- category : Optimization Suggestion
- severity : Informational
#### Description
The callcode function is disabled in compiler version 0.5.0 and above, because the callcode call will set the caller's msg.sender to the caller's address.
#### Recommendation
It is recommended to use delegatecall instead of callcode function.
### HexPrefix_Issue
#### Properties
- name : Literal Hex Starts with 0X
- category : Optimization Suggestion
- severity : Informational
#### Description
For contracts with compiler of version below 0.5.0, the hexadecimal constants start with 0X.
#### Recommendation
It is recommended that the hexadecimal constants in the contract do not start with 0X.
### NeverCalledFunction_Issue_Public
#### Properties
- name : Function Visibility Can Be External
- category : Optimization Suggestion
- severity : Informational
#### Description
Functions that are not called should be declared as external.
#### Recommendation
Functions that are not called in the contract should be declared as external.
### ConstructorValidation_Issue
#### Properties
- name : Constructor in Base Contract Not Implemented
- category : Optimization Suggestion
- severity : Informational
#### Description
The constructor in the base class is not implemented which may cause execution failures.
#### Recommendation
Before calling the constructor of the base class, check whether the constructor has been implemented.
### ArrayLengthManipulation_Issue
#### Properties
- name : Array Length Manipulation
- category : Optimization Suggestion
- severity : Informational
#### Description
The length of the dynamic array is changed directly by using .length++ or .length--. In this case, the appearance of gigantic arrays is possible and it can lead to a storage overlap attack (collisions with other data in storage).
#### Recommendation
It is recommended to use .push() and .pop() for operations on dynamic arrays.
### RandomAccessToEnum_Issue
#### Properties
- name : Externally Controlled Enum
- category : Optimization Suggestion
- severity : Informational
#### Description
A variable that can be controlled is used when reading the enumeration variable, which may go out of bounds and cause the transaction to be reverted.
#### Recommendation
Variables that can be controlled should not be used when reading enumerated variables.
### No_SolcVersion_Issue
#### Properties
- name : Solidity Pragma Not Exist
- category : Optimization Suggestion
- severity : Informational
#### Description
The compiler version is not specified in the contract, which may cause the contract to be compiled by an untested compiler, resulting in some security risks.
#### Recommendation
The compiler version must be specified in the contract.
### StateVariablesChangeInViewFunction_Issue
#### Properties
- name : Storage Manipulation in constant/pure/view Function
- category : Optimization Suggestion
- severity : Informational
#### Description
If the state variable or the variable whose storage location is storage is modified in the constant/pure/view function, the compiler will report an error.
#### Recommendation
State variables should not be modified in constant/pure/view functions.
### EmitEvent_Issue
#### Properties
- name : Emit Keyword Missing Before the Event Call
- category : Optimization Suggestion
- severity : Informational
#### Description
Compilers of 0.4.21 and above already support the emit keyword, so it is recommended to use the emit keyword to send events.
#### Recommendation
Contracts using compiler version 0.4.21 and above should use the emit keyword to send events.
### IfCondWithBool_Issue
#### Properties
- name : Comparison With Literal Boolean
- category : Optimization Suggestion
- severity : Informational
#### Description
Boolean constants can be used directly and do not need to be compare to true or false.
#### Recommendation
Remove Boolean constants' comparison in conditional statements.
### IncorrectUnary_Issue
#### Properties
- name : Inappropriate Usage of "=+"
- category : Optimization Suggestion
- severity : Informational
#### Description
"=+" may be used incorrectly, and the operation has been discarded by the compiler in version 0.5.0.
#### Recommendation
Remove the =+ expression.
### IncorrectModifier_Issue
#### Properties
- name : Paths in the Modifier Not End with "_" or Revert
- category : Optimization Suggestion
- severity : Informational
#### Description
If a branch in the modifier does not execute the code pointed to by _, and does not execute revert, then the function using the modifier will return the default value, resulting in unexpected behavior.
#### Recommendation
All branches in the modifier should execute the code pointed to by _ or revert.
### Msgvalue_Issue
#### Properties
- name : Non-payable Public Functions Use msg.value
- category : Optimization Suggestion
- severity : Informational
#### Description
Non-payable public functions are prohibited from using msg.value, because such functions do not have the ability to receive ETH.
#### Recommendation
Add payable to the function, or remove the use of msg.value in the function.
### WriteStateInAssert_Issue
#### Properties
- name : Storage Manipulation in assert
- category : Optimization Suggestion
- severity : Informational
#### Description
Assert should only be used to test for internal errors or to check invariants.
#### Recommendation
State variables should not be modified in assert, function require should be used instead.
### WriteStateInModifier_Issue
#### Properties
- name : Storage Manipulation in Modifier
- category : Optimization Suggestion
- severity : Informational
#### Description
Change state variable in modifier may cause unexpected behavior.
#### Recommendation
Except for the non-reentrancy function, only state variables should be checked in the modifier and should not be changed.
### ABIEncodePacked_Issue
#### Properties
- name : abi.encodePacked() Hash Collision
- category : Optimization Suggestion
- severity : Informational
#### Description
The abi.encodePacked() method is used for serialization. When the parameter contains multiple variable-length arrays, two variable-length arrays with different elements may have the same serialization result.
#### Recommendation
It is recommended to check whether the parameters of abi.encodePacked() are externally controllable, or use abi.encode() for serialization.
### SafeMath_Issue
#### Properties
- name : Use SafeMath When Compiler Version below 0.8.0
- category : Optimization Suggestion
- severity : Informational
#### Description
Contracts using compiler versions below 0.8.0 are recommended to use the SafeMath library to prevent overflow of arithmetic operation.
#### Recommendation
It is recommended to use the SafeMath library for contracts using compiler versions below 0.8.0.
### ReturnStopInAssembly_Issue
#### Properties
- name : Recommended Not to Use NonReentrant Modifier When return/stop Statements Exist in Assembly
- category : Optimization Suggestion
- severity : Informational
#### Description
The return or stop statement in the assembly will directly terminate the execution of the program, so that the statement after the placeholder _ in the modifier will not be executed, resulting in problems like reentrant lock deadlock.
#### Recommendation
Please be careful not to add NonReentrancy modifier to this function.
### ReentrancyGuardInNonExternalFunc_Issue
#### Properties
- name : ReentrancyGuard Should Modify External Function
- category : Optimization Suggestion
- severity : Informational
#### Description
The reentrancy guard modifier should modify the external function, because reentrancy vulnerabilities often occur in external calls.
#### Recommendation
It is recommended not to put reentrancy guard modifier in non-external functions.
### TooManyDigits_Issue
#### Properties
- name : Too Many Digits
- category : Optimization Suggestion
- severity : Informational
#### Description
The number is too long, and it is easy to make mistakes when modifying and maintaining.
#### Recommendation
It is recommended to convert to a constant value, which is easier to maintain.
### InterfaceDefinedNotInherited_Issue
#### Properties
- name : Interface Defined Not Inherited
- category : Optimization Suggestion
- severity : Informational
#### Description
There is an interface definition, but the interface is not inherited when the contract is defined.
#### Recommendation
It is recommended that the contract inherits the relevant interface when it is defined.
### RevertInsteadOfRequireFalse_Issue
#### Properties
- name : Recommended to use revert() instead of require(false,'')
- category : Optimization Suggestion
- severity : Informational
#### Description
If the condition of a require function is always false, it equals to a revert function.
#### Recommendation
It is recommended to use the revert function instead of require(false,'').
### CriticalStateVariableMissingEvent_Issue
#### Properties
- name : Event Should be Emitted When Critical State Variables Change
- category : Optimization Suggestion
- severity : Informational
#### Description
When some critical variables in the contract, such as owner and balance change, an event should be emitted so that the changes of these variables can be tracked off-chain.
#### Recommendation
It is recommended to emit an event when critical variables change.
### SignatureReplay_Issue
#### Properties
- name : Check Risk of Transaction Replay
- category : Optimization Suggestion
- severity : Informational
#### Description
Be aware of transaction replay risks when using signatures.
#### Recommendation
It is recommended to check whether there is a transaction replay risk.
### NoCheckAddressParams_Issue
#### Properties
- name : No Check of Address Params with Zero Address
- category : Optimization Suggestion
- severity : Informational
#### Description
The input parameter of the address type in the function does not use the zero address for verification.
#### Recommendation
It is recommended to perform zero address verification on the input parameters of the address type.
### OrderOfLayout_Issue
#### Properties
- name : Recommended to Follow Code layout Conventions.
- category : Optimization Suggestion
- severity : Informational
#### Description
In the solidity document(https://docs.soliditylang.org/en/v0.8.17/style-guide.html), there are the following conventions for code layout:
Layout contract elements in the following order: 1. Pragma statements, 2. Import statements, 3. Interfaces, 4. Libraries, 5. Contracts.
Inside each contract, library or interface, use the following order: 1. Type declarations, 2. State variables, 3. Events, 4. Modifiers, 5. Functions.
Functions should be grouped according to their visibility and ordered: 1. constructor, 2. receive function (if exists), 3. fallback function (if exists), 4. external, 5. public, 6. internal, 7. private.
#### Recommendation
It is recommended to follow the above code layout conventions to improve code readability.
### EmptyFunctionBody_Issue
#### Properties
- name : Empty Function Body
- category : Optimization Suggestion
- severity : Informational
#### Description
The body of this function is empty.
#### Recommendation
It is recommended to check whether the function body is leaked.
### SpecifyMultipleCompilerVersions_Issue
#### Properties
- name : Specify Multiple Compiler Versions
- category : Optimization Suggestion
- severity : Informational
#### Description
Multiple compiler versions are specified in one contract file.
#### Recommendation
It is recommended to use a fixed compiler version.
### UseObsoleteSyntax_Issue
#### Properties
- name : Use Obsolete Syntax
- category : Optimization Suggestion
- severity : Informational
#### Description
Some functions and keywords in solidity have been deprecated. Using these deprecated syntaxes will reduce the code quality or cause compilation errors. For details, please refer to https://swcregistry.io/docs/SWC-111.
#### Recommendation
It is recommended to use new function names or keywords instead of deprecated syntax.
### SmallerType_Issue
#### Properties
- name : Prefer uint256
- category : Optimization Suggestion
- severity : Informational
#### Description
It is recommended to replace integer types that are not 32 bytes in size and cannot be combined with other storage with uint256 to avoid the gas overhead caused by filling 32 bytes in operation.
#### Recommendation
It is recommended to replace integer types that are not 32 bytes in size and cannot be combined with other storage with uint256.
### BytesInsteadOfByteArr_Issue
#### Properties
- name : Prefer bytes to byte[]
- category : Optimization Suggestion
- severity : Informational
#### Description
When using byte[] to define variables, more gas will be consumed.
#### Recommendation
It is recommended to use bytes.
### Return_Issue_Improve
#### Properties
- name : Optimizable Return Statement
- category : Optimization Suggestion
- severity : Informational
#### Description
The returned variable is specified in the function signature, but the return statement is still displayed in the function body, which will increase gas consumption.
#### Recommendation
No need to explicitly call the return statement when the returned variable is specified in the function signature.
### Return_Issue_Clarify
#### Properties
- name : Clarify Return Value
- category : Optimization Suggestion
- severity : Low
#### Description
The returned variable is specified in the function signature, but it still calls the return statement to return a local variable defined in the function body or state variable. It is necessary to clarify whether the returned value meets expectations.
#### Recommendation
It is recommended to be clear whether the returned value is as expected, and only use one way to return the value.
### ReturnCheck_Issue
#### Properties
- name : Return Value Unspecified
- category : Optimization Suggestion
- severity : Informational
#### Description
The function signature declares that there is a return value, but there is no return value in the actual code, the compiler will return the default value of the return type.
#### Recommendation
If the function in the contract does not need to return a value, do not specify returns in the function signature.
### Tautology_Issue
#### Properties
- name : Tautology Issue
- category : Optimization Suggestion
- severity : Informational
#### Description
Since inequality comparisons cost less gas than larger, it is recommended to convert uint-to-zero comparisons to uint-to-zero inequality comparisons.
#### Recommendation
Since inequality comparisons cost less gas than larger, it is recommended to convert uint-to-zero comparisons to uint-to-zero inequality comparisons.
### UnusedImport_Issue
#### Properties
- name : Unused Import Contract
- category : Optimization Suggestion
- severity : Informational
#### Description
Import's contract is not used, which will increase gas consumption.
#### Recommendation
It is recommended to delete unused Import contracts.
### UnusedFunctionParameter_Issue
#### Properties
- name : Unused Function Parameters
- category : Optimization Suggestion
- severity : Informational
#### Description
The parameters of the function are not used, which will increase the gas consumption.
#### Recommendation
It is recommended to remove unused function parameters.
### NeverCalledFunction_Issue_Internal
#### Properties
- name : Unused Internal Function
- category : Optimization Suggestion
- severity : Informational
#### Description
Internal functions is defined but not used, which will add gas consumption.
#### Recommendation
It is recommended to delete functions that are not called.
### NoStateVariablesChangeInFunction_Issue
#### Properties
- name : Function Visibility Can Be View
- category : Optimization Suggestion
- severity : Informational
#### Description
When there is no state modification operation in the function, you can mark the visibility of the function as view, otherwise it will increase gas consumption.
#### Recommendation
When there is no state-modifying operation in the function, the visibility of the function can be marked as view.
### Calldata_Issue
#### Properties
- name : Parameters in External Function should declared as Calldata
- category : Optimization Suggestion
- severity : Informational
#### Description
When the compiler parses the external function, it can directly read the function parameters from calldata. Setting it to other storage locations may waste gas.
#### Recommendation
In external functions, the storage location of function parameters should be set to calldata to save gas.
### UninitializedVariable_Issue_Unused
#### Properties
- name : Unused State Variables
- category : Optimization Suggestion
- severity : Informational
#### Description
The state variables are not used, which will increase the gas consumption.
#### Recommendation
It is recommended to remove unused state variables.
### DuplicateCode_Issue
#### Properties
- name : Duplicate Code in Contract
- category : Optimization Suggestion
- severity : Informational
#### Description
There is duplicate code in the contract which will increase gas consumption.
#### Recommendation
It is recommended to avoid duplication of code in contracts to save gas.
### DeleteStructContainsMapping_Issue
#### Properties
- name : Delete Struct Containing the Mapping Type
- category : Optimization Suggestion
- severity : Informational
#### Description
The structure containing the mapping type is deleted in the contract, but the mapping will not be deleted.
#### Recommendation
When deleting a structure, check whether there is a mapping type variable in the structure, and if so, delete mapping first and then delete the struct.
### SafeMathUsage_Issue
#### Properties
- name : No Need To Use SafeMath in Solidity Contract of Version 0.8.0 and Above
- category : Optimization Suggestion
- severity : Informational
#### Description
In solidity 0.8.0 and above, the compiler has its own overflow checking function, so there is no need to use the SafeMath library to prevent overflow.
#### Recommendation
It is recommended to abandon the use of the SafeMath library to prevent overflow, which can save gas in versions 0.8.0 and above, unless you want to specify the error message when overflowing or you are using the openzeppelin library of version 0.4 and above.
### NoChangedVariables_Issue
#### Properties
- name : Variables Should Be Constants
- category : Optimization Suggestion
- severity : Informational
#### Description
There are unchanging state variables in the contract, and putting unchanging state variables in storage will waste gas.
#### Recommendation
The unchanging state variables in the contract should be declared as constants, which can save gas.
### PreIncrementInsteadOfPostIncrement_Issue
#### Properties
- name : Use ++i/--i instead of i++/i--
- category : Optimization Suggestion
- severity : Informational
#### Description
Compared with i++, ++i can save about 5 gas per use.Compared with i--, --i can save about 3 gas per use in for loop.
#### Recommendation
It is recommended to use ++i/--i instead of i++/i-- in for loop.
### GetBalanceInAssembly_Issue
#### Properties
- name : Get Contract Balance of ETH in Assembly
- category : Optimization Suggestion
- severity : Informational
#### Description
Using the selfbalance and balance opcodes to get the ETH balance of the contract in assembly saves gas compared to getting the ETH balance through address(this).balance and xx.balance.
#### Recommendation
It is recommended to get the contract ETH balance in assembly.
### CheaperAssignment_Issue
#### Properties
- name : Assign Values to Array Elements Using +=/-=
- category : Optimization Suggestion
- severity : Informational
#### Description
In a loop, using +=/-= to assign values to array elements saves gas compared to simple assignments.
#### Recommendation
It is recommended to use +=/-= to assign values to array elements in a loop. For example, use arr[i] += 1 instead of arr[i] = arr[i] + 1.
### LongRevertString_Issue
#### Properties
- name : Long String in revert/require
- category : Optimization Suggestion
- severity : Informational
#### Description
If the string parameter in the revert/require function exceeds 32 bytes, more gas will be consumed.
#### Recommendation
It is recommended to control the length of the string parameter in the revert/require function within 32 bytes.
### UsePrivateConstant_Issue
#### Properties
- name : Set the Constant to Private
- category : Optimization Suggestion
- severity : Informational
#### Description
For constants, if the visibility is set to public, the compiler will automatically generate a getter function for it, which will consume more gas during deployment than private.
#### Recommendation
It is recommended to set the visibility of constants to private instead of public.
### UseCustomError_Issue
#### Properties
- name : Use CustomError Instead of String
- category : Optimization Suggestion
- severity : Informational
#### Description
When using revert, using CustomError is more gas efficient than string description. Because the error message described using CustomError is only compiled into four bytes.
#### Recommendation
When reverting, it is recommended to use CustomError instead of ordinary strings to describe the error message.
### UseShiftInsteadOfMulDiv_Issue
#### Properties
- name : Use Shift Operation Instead of Mul/Div
- category : Optimization Suggestion
- severity : Informational
#### Description
It is recommended to use shift operation instead of direct multiplication and division if possible, because shift operation is more gas-efficient.
#### Recommendation
It is recommended to use shift operation instead of multiplication and division when possible.
### CacheStateVariables_Issue
#### Properties
- name : Cache State Variables that are Read Multiple Times within A Function
- category : Optimization Suggestion
- severity : Informational
#### Description
When a state variable is read multiple times in a function, using a local variable to cache the state variable can avoid frequently reading data from storage, thereby saving gas.
#### Recommendation
When a state variable is read multiple times in a function, it is recommended to use a local variable to cache the state variable.
### UnsignedComparison_Issue
#### Properties
- name : Use != 0 Instead of > 0 for Unsigned Integer Comparison
- category : Optimization Suggestion
- severity : Informational
#### Description
For unsigned integers, use !=0 for comparison, which consumes less gas than >0.
#### Recommendation
For unsigned integers, it is recommended to use !=0 instead of >0 for comparison.
### CheckZeroAddressInAssembly_Issue
#### Properties
- name : Use Assembly to Check Zero Address
- category : Optimization Suggestion
- severity : Informational
#### Description
Using assembly to check zero address can save gas.
#### Recommendation
It is recommended to use assembly to check zero address.
### ContinuousStateWrite_Issue
#### Properties
- name : Continuous State Variable Write
- category : Optimization Suggestion
- severity : Informational
#### Description
When multiple write operations are performed on a state variable without interval read operations, the intermediate write operations are redundant and waste gas.
#### Recommendation
It is recommended to remove redundant state variable writes.
### VariableCanBeImmutable_Issue
#### Properties
- name : Variables Can Be Modified with Immutable
- category : Optimization Suggestion
- severity : Informational
#### Description
The solidity compiler of version 0.6.5 introduces immutable to modify state variables that are only modified in the constructor. Using immutable can save gas.
#### Recommendation
For contracts compiled with compiler of versions 0.6.5 and above, if the state variable is only modified in the constructor, it is recommended to modify the variable with immutable to save gas.
