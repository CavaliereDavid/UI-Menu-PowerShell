# UI-Menu
We run our program using powershell and applying the best practices from: https://github.com/PoshCode/PowerShellPracticeAndStyle  . 
There are going to be multiple commits in order to keep track of the code being improved. 
1. We started our program by using only params without using cmdLetBinding().
2. Now  We are going to upgrade the current code and give It a better structure.
3. Added a try catch block as a scriptblock
4. Added validation method in order to improve readability and avoid redundancy in folder-utils.

In the first commmit We have already upgraded our code by adding cmdLetBinding and by adding try catch block to better handle errors. 
In the second commit We are going to Invoke a method to do the try, catch in order to improve the readability of the code and avoid using repetitive code.
