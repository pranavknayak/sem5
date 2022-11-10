.data
L1: .word 0                     #This location indicates the error of the result. It is 0 if no error else 1.
D1: .word 3, 3                      #x and y dimensions of MATRIX-1
M1: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
D2: .word 3, 3
M2: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
D3: .word 0, 0                        #These values are overwritten in case of a successful multiply
M3: .word 0                           #The resultant matrix is stored here, corresponding to byte 4 of memory location 0x10000060
                                      #with each value being stored 4 bytes after the previous one

.text
main:
      la t1, D1
      lw t1, 0(t1)        #t1 stores rows of matrix 1
      la t2, D1
      lw t2, 4(t2)        #t2 stores columns of matrix 1
      la t3, D2
      lw t3, 0(t3)        #t3 stores rows of matrix 2
      la t4, D2
      lw t4, 4(t4)        #t4 stores columns of matrix 2
      
      beq t2, t3, MULTIPLY
      la x3, L1
      addi x1, x1, 1
      sw x1, 0(x3)
      bne t2, t3, END
      
      MULTIPLY:
      
          la s3, D3         #s3 points to the dimensions of the product matrix
          sw t1, 0(s3)
          sw t4, 4(s3)
      
                           #a1, a2 and a3 are loop counters
          add a1, x0, x0   #a1 loops through rows of matrix-1 
          add a2, x0, x0   #a2 loops through columns of matrix-2
          add a3, x0, x0   #a3 loops within the row and column selected by the previous two
          
          la t5, M1        #t5 stores the address of the current matrix-1 element
          la t6, M2        #t6 stores the address of the current matrix-2 element
          
          la t0, M3        #t0 stores the address to be written to
      
          LOOP1: beq a1, t1, LOOP1END
              add a2, x0, x0
              
              add a5, x0, x0 #a5 stores the decrement in t5, so that it can be reset to point to the start of the row
              LOOP2: beq a2, t4, LOOP2END
                  add a3, x0, x0
                  add s11, x0, x0 #s11 stores the result of the current row-column inner-product
                  
                  add a6, x0, x0 #a6 stores the total increment in t6
                  LOOP3: beq a3, t2, LOOP3END
                      
                      lw s9, 0(t5)    #s9 stores the current matrix-1 element
                      lw s10, 0(t6)   #s10 stores the current matrix-2 element
                  
                      mul s8, s9, s10 #s8 stores the product of the two elements
                      add s11, s11, s8
                      
                      addi t5, t5, 4 #increment t5 so it points to the next element in the row of matrix-1
                      addi a5, a5, 4 #stores the total increment in t5, so that it can be reset later
                      addi s6, x0, 4 #s6 is used to store the increment of t6
                      mul s6, s6, t4 #the increment is the number of columns of matrix-2 (multiplied by word size)
                      
                      add t6, t6, s6 #increment t6 so that it points to the next element in the column of matrix-2
                      add a6, a6, s6 #keep count of the total increase in t6
                      
                      addi a3, a3, 1
                      bne a3, t2, LOOP3    
                  LOOP3END:
                  sw s11, 0(t0) #writes the current inner-product to the memory location
                  addi t0, t0, 4 #increments t0 by 4 to point to the next matrix element
                      
                  addi s5, x0, 4 #s5 stores the decrement in t5
                  mul s5, s5, t2 #t5 needs to be reset to its original position, i.e. at the start of a row
                  sub t5, t5, s5
                  
                  sub t6, t6, a6 #reset t6 to pointing to the top of the column in matrix-2
                  addi t6, t6, 4 #move t6 to point to the next column
                  
                  addi a2, a2, 1
                  bne a2, t4, LOOP2
              LOOP2END:
              la t6, M2 #resets t6 to point to the top of the first column of matrix-2
              
           
              lw s9, 0(t5)
              addi a5, x0, 4 #a5 now stores by how much t5 should be increased to point to the start of the next row
              mul a5, a5, t2 #t5 should be incremented by a whole column to point to the start of the next row
              add t5, t5, a5 
              lw s9, 0(t5)
          
          addi a1, a1, 1                           
          bne a1, t1, LOOP1    
          LOOP1END:
              
      
              
      
      END:
          
          addi x0, x0, 0 #dummy code so the label is valid
      