    .intel_syntax noprefix
    .global main
    .extern printf

    .data
banner:
    .asciz "========================================================\n         x86_64 ASM CPUID FEATURE DETECTOR              \n========================================================\n\n"
fmt_vendor:
    .asciz "CPU Vendor ID : %s\n"
fmt_brand:
    .asciz "CPU Brand     : %s\n\n[ INSTRUCTION SET CAPABILITIES ]\n"
fmt_feat:
    .asciz "  %-12s : %s\n"
str_yes:
    .asciz "[+] SUPPORTED"
str_no:
    .asciz "[-] NOT SUPPORTED"

feat_sse:    .asciz "SSE"
feat_sse2:   .asciz "SSE2"
feat_sse3:   .asciz "SSE3"
feat_ssse3:  .asciz "SSSE3"
feat_sse41:  .asciz "SSE4.1"
feat_sse42:  .asciz "SSE4.2"
feat_avx:    .asciz "AVX"
feat_avx2:   .asciz "AVX2"
feat_aes:    .asciz "AES-NI"
feat_rdrand: .asciz "RDRAND"

footer:
    .asciz "\n========================================================\n"

    .bss
vendor_str:
    .space 16
brand_str:
    .space 64

    .text
main:
    sub rsp, 40

    lea rcx, [rip + banner]
    call printf

    xor eax, eax
    cpuid
    lea rdi, [rip + vendor_str]
    mov [rdi], ebx
    mov [rdi + 4], edx
    mov [rdi + 8], ecx
    mov byte ptr [rdi + 12], 0

    lea rcx, [rip + fmt_vendor]
    lea rdx, [rip + vendor_str]
    call printf

    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000004
    jb skip_brand

    lea rdi, [rip + brand_str]
    mov eax, 0x80000002
    cpuid
    mov [rdi], eax
    mov [rdi + 4], ebx
    mov [rdi + 8], ecx
    mov [rdi + 12], edx

    mov eax, 0x80000003
    cpuid
    mov [rdi + 16], eax
    mov [rdi + 20], ebx
    mov [rdi + 24], ecx
    mov [rdi + 28], edx

    mov eax, 0x80000004
    cpuid
    mov [rdi + 32], eax
    mov [rdi + 36], ebx
    mov [rdi + 40], ecx
    mov [rdi + 44], edx
    mov byte ptr [rdi + 48], 0

    lea rcx, [rip + fmt_brand]
    lea rdx, [rip + brand_str]
    call printf

skip_brand:
    mov eax, 1
    cpuid
    mov r12d, ecx
    mov r13d, edx

    # SSE
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_sse]
    bt r13d, 25
    jc .L_sse_yes
    lea r8, [rip + str_no]
    jmp .L_sse_print
.L_sse_yes:
    lea r8, [rip + str_yes]
.L_sse_print:
    call printf

    # SSE2
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_sse2]
    bt r13d, 26
    jc .L_sse2_yes
    lea r8, [rip + str_no]
    jmp .L_sse2_print
.L_sse2_yes:
    lea r8, [rip + str_yes]
.L_sse2_print:
    call printf

    # SSE3
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_sse3]
    bt r12d, 0
    jc .L_sse3_yes
    lea r8, [rip + str_no]
    jmp .L_sse3_print
.L_sse3_yes:
    lea r8, [rip + str_yes]
.L_sse3_print:
    call printf

    # SSSE3
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_ssse3]
    bt r12d, 9
    jc .L_ssse3_yes
    lea r8, [rip + str_no]
    jmp .L_ssse3_print
.L_ssse3_yes:
    lea r8, [rip + str_yes]
.L_ssse3_print:
    call printf

    # SSE4.1
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_sse41]
    bt r12d, 19
    jc .L_sse41_yes
    lea r8, [rip + str_no]
    jmp .L_sse41_print
.L_sse41_yes:
    lea r8, [rip + str_yes]
.L_sse41_print:
    call printf

    # SSE4.2
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_sse42]
    bt r12d, 20
    jc .L_sse42_yes
    lea r8, [rip + str_no]
    jmp .L_sse42_print
.L_sse42_yes:
    lea r8, [rip + str_yes]
.L_sse42_print:
    call printf

    # AVX
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_avx]
    bt r12d, 28
    jc .L_avx_yes
    lea r8, [rip + str_no]
    jmp .L_avx_print
.L_avx_yes:
    lea r8, [rip + str_yes]
.L_avx_print:
    call printf

    # AES-NI
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_aes]
    bt r12d, 25
    jc .L_aes_yes
    lea r8, [rip + str_no]
    jmp .L_aes_print
.L_aes_yes:
    lea r8, [rip + str_yes]
.L_aes_print:
    call printf

    # RDRAND
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_rdrand]
    bt r12d, 30
    jc .L_rdrand_yes
    lea r8, [rip + str_no]
    jmp .L_rdrand_print
.L_rdrand_yes:
    lea r8, [rip + str_yes]
.L_rdrand_print:
    call printf

    # AVX2 (EAX = 7, ECX = 0)
    mov eax, 7
    xor ecx, ecx
    cpuid
    lea rcx, [rip + fmt_feat]
    lea rdx, [rip + feat_avx2]
    bt ebx, 5
    jc .L_avx2_yes
    lea r8, [rip + str_no]
    jmp .L_avx2_print
.L_avx2_yes:
    lea r8, [rip + str_yes]
.L_avx2_print:
    call printf

    lea rcx, [rip + footer]
    call printf

    xor eax, eax
    add rsp, 40
    ret
