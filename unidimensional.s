.data
    v: .space 4096

    nr_op: .space 4
    op: .space 4
    descriptor: .space 4
    dimensiune: .space 4
    nr: .space 4

    stg: .space 4
    dr: .space 4

    cit: .asciz "%d"
    afis1: .asciz "%d\n"
    afis: .asciz "%d: (%d, %d)\n"
    afis_get: .asciz "(%d, %d)\n"

    index: .space 4
    index1: .space 4
.text



adauga:
    movl $0, stg
    movl $0, dr
    lea v, %esi

    xorl %edx, %edx
    movl dimensiune, %eax
    addl $7, %eax
    movl $8, %ebx
    divl %ebx
    movl %eax, dimensiune
    

    et_cautare_stanga:
        movl $1024, %eax
        cmp %eax, stg
        jae eroare

        movl stg, %eax
        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_stanga

        movl stg, %ebx
        inc %ebx
        movl %ebx, dr

    et_cautare_dreapta:
        movl $1024, %eax
        cmp %eax, dr
        jae eroare 

        movl dr, %eax
        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_stanga

        subl stg, %eax
        inc %eax
        cmp dimensiune, %eax
        je et_gasit
    
        movl dr, %eax
        inc %eax
        movl %eax, dr
        jmp et_cautare_dreapta

    et_stanga:
        movl stg, %eax
        inc %eax
        movl %eax, stg
        jmp et_cautare_stanga

    et_gasit:
        movl stg, %ebx
        movl descriptor, %eax

    et_adauga_descriptor:
        cmp dr, %ebx
        ja afisare_interval

        movl %eax, (%esi, %ebx,4)
        inc %ebx
        jmp et_adauga_descriptor

afisare_interval:
    pushl dr
    pushl stg
    pushl descriptor
    pushl $afis
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    ret

eroare:
    movl $0, stg
    movl $0, dr
    jmp afisare_interval

eroare_get:
    movl $0, stg
    movl $0, dr
    jmp et_afis_get


get:
    movl $0, stg
    movl $0, dr
    lea v, %esi

    et_stg:
        movl $1024, %eax
        cmp %eax, stg
        jae eroare_get

        movl stg, %eax
        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        je et_gasit_stg

        inc %eax
        movl %eax, stg
        jmp et_stg

    et_gasit_stg:
        movl stg, %eax
        inc %eax
        movl %eax, dr

    et_dr:
        movl $1024, %eax
        cmp %eax, dr
        jae et_gasit_dr

        movl dr, %eax
        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        jne et_gasit_dr

        inc %eax
        movl %eax, dr
        jmp et_dr

    et_gasit_dr:
        dec %eax
        movl %eax, dr
    
    et_afis_get:
        pushl dr
        pushl stg
        pushl $afis_get
        call printf
        popl %ebx
        popl %ebx
        popl %ebx

        pushl $0
        call fflush
        popl %ebx

        ret

delete:
    movl $0, stg
    movl $0, dr
    lea v, %esi

    et_stg_del:
        movl $1024, %eax
        cmp %eax, stg
        jae afisare_vector

        movl stg, %eax
        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        je et_gasit_stg_del

        inc %eax
        movl %eax, stg
        jmp et_stg_del

    et_gasit_stg_del:
        movl stg, %eax
        movl %eax, dr

    et_dr_del:
        movl $1024, %eax
        cmp %eax, dr
        jae et_gasit_dr_del

        movl dr, %eax
        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        jne et_gasit_dr_del

        movl $0, %ebx
        movl %ebx, (%esi,%eax,4)
        inc %eax
        movl %eax, dr
        jmp et_dr_del

    et_gasit_dr_del:
        dec %eax
        movl %eax, dr

        jmp afisare_vector

defrag:
    movl $0, stg
    movl $0, dr
    lea v, %esi

    et_cautare_zero:
        movl $1024, %eax
        cmp %eax, stg
        jae afisare_vector

        movl stg, %eax
        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        je et_gasit_zero

        inc %eax
        movl %eax, stg
        jmp et_cautare_zero

    et_gasit_zero:
        movl stg, %eax
        movl %eax, dr
    
    et_contor:
        movl $1024, %eax
        cmp %eax, dr
        jae afisare_vector

        movl dr, %eax
        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_mutare

        inc %eax
        movl %eax, dr
        jmp et_contor

    et_mutare:
        movl $1024, %eax
        cmp dr, %eax
        je defrag

        movl dr, %eax
        movl stg, %ebx
        movl (%esi,%eax,4), %ecx
        movl %ecx, (%esi,%ebx,4)
        movl $0, (%esi, %eax,4) 

        inc %eax
        movl %eax, dr
        inc %ebx
        movl %ebx, stg

        jmp et_mutare
        

afisare_vector:
    movl $0, stg
    movl $0, dr
    lea v, %esi

    et_int_stg:
        movl $1024, %eax
        cmp %eax, stg
        jae et_gata_afis

        movl stg, %eax
        movl (%esi,%eax,4), %ebx
        cmp $0, %ebx
        jne et_gasit_int_stg

        inc %eax
        movl %eax, stg
        jmp et_int_stg

    et_gasit_int_stg:
        movl (%esi,%eax,4), %ebx
        movl %ebx, descriptor

        movl stg, %eax
        inc %eax
        movl %eax, dr

    et_int_dr:
        movl $1024, %eax
        cmp %eax, dr
        je et_gasit_int_dr ;// afisarea intervalului pt capat de vector

        movl dr, %eax
        movl (%esi,%eax,4), %ebx
        cmp descriptor, %ebx
        jne et_gasit_int_dr

        inc %eax
        movl %eax, dr
        jmp et_int_dr

    et_gasit_int_dr:
        dec %eax
        movl %eax, dr

        call afisare_interval
        movl dr, %eax
        inc %eax
        movl %eax, stg

        jmp et_int_stg
    
    et_gata_afis:
        ret

.global main

main:
    pushl $nr_op
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

et_citire_op:
    movl index1, %ecx
    cmp nr_op, %ecx
    je et_exit

    pushl $op
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    movl op, %ebx

    cmp $1, %ebx
    je et_citire_fis

    cmp $2, %ebx
    je et_get_cit

    cmp $3, %ebx
    je et_delete_cit

    cmp $4, %ebx
    je et_defrag_cit

et_final_op:
    movl index1, %ecx
    inc  %ecx
    movl %ecx, index1
    jmp et_citire_op

et_citire_fis:
    pushl  $nr
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    xor %eax, %eax
    movl %eax, index

et_add_cit:
    movl index, %eax
    cmp nr, %eax
    je et_final_op

    pushl $descriptor
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    pushl  $dimensiune
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    call adauga

    movl index, %eax
    inc %eax
    movl %eax, index
    jmp et_add_cit

et_get_cit:
    pushl $descriptor
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    call get

    jmp et_final_op

et_delete_cit:
    pushl $descriptor
    pushl $cit
    call scanf
    popl %ebx
    popl %ebx

    call delete

    jmp et_final_op

et_defrag_cit:
    call defrag

    jmp et_final_op

et_exit:
    pushl $0
    call fflush
    popl %eax

    movl $1, %eax
    xorl %ebx, %ebx  
    int $0x80
