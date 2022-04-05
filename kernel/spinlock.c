#include "include/spinlock.h"
#include "include/riscv.h"
#include "include/printk.h"

void init_spinlock(spinlock* lock, char* name){
    lock->is_locked=0;
    lock->name=name;
}

// Acquire the lock.
// Loops (spins) until the lock is acquired.
void acquire_spinlock(struct spinlock *lock){
  //push_off(); 
  intr_on();// disable interrupts to avoid deadlock.
  if(is_holding_spinlock(lock))
    panic("acquire");

  // On RISC-V, sync_lock_test_and_set turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  while(__sync_lock_test_and_set(&lock->is_locked, 1) != 0)
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  // Record info about lock acquisition for is_holding_spinlock() and debugging.

}

// Release the lock.
void release_spinlock(struct spinlock *lock){
  if(!is_holding_spinlock(lock))
    panic("release");
  // Tell the C compiler and the CPU to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  // Release the lock, equivalent to lk->locked = 0.
  // This code doesn't use a C assignment, since the C standard
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lock->is_locked);

  //pop_off();
  intr_off();
}

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int is_holding_spinlock(struct spinlock *lock){
   /*
  int r;
  r = (lk->is_locked && lk->cpu == mycpu());
  return r;
  */
 return lock->is_locked;
}