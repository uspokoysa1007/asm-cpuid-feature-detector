# asm-cpuid-feature-detector

Детектор возможностей процессора на чистом x86_64 ассемблере (GNU Assembler / GAS) для Windows.

## Возможности
- Прямой вызов инструкции `cpuid` на уровне регистров процессора.
- Извлечение строки производителя (Vendor ID, например `GenuineIntel` или `AuthenticAMD`).
- Извлечение полного наименования процессора (Processor Brand String, 48 байт).
- Проверка бит-флагов регистров `ECX`, `EDX`, `EBX`:
  - **AVX, AVX2, SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2, AES, FMA, RDRAND**.
- Полное соблюдение Windows x64 ABI (Shadow space, выравнивание стека по 16 байт).

## Сборка
```bash
gcc -O2 src/main.s -o releases/asm-cpuid-feature-detector.exe
```

## Использование
```bash
./releases/asm-cpuid-feature-detector.exe
```
