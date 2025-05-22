0000: addi $s1, $zero, 1
0001: j 0x00003014
0002: addi $s1, $zero, 1
0003: addi $s2, $zero, 2
0004: addi $s3, $zero, 3
0005: j 0x00003024
0006: addi $s1, $zero, 1
0007: addi $s2, $zero, 2
0008: addi $s3, $zero, 3
0009: j 0x00003034
0010: addi $s1, $zero, 1
0011: addi $s2, $zero, 2
0012: addi $s3, $zero, 3
0013: j 0x00003044
0014: addi $s1, $zero, 1
0015: addi $s2, $zero, 2
0016: addi $s3, $zero, 3
0017: jal 0x000034B8
0018: addi $s0, $zero, 1
0019: addi $s1, $zero, 1
0020: sll $s1, $s1, 31
0021: add $a0, $zero, $s1
0022: addi $v0, $zero, 34
0023: syscall
0024: srl $s1, $s1, 2
0025: beq $s1, $zero, 1
0026: j 0x00003054
0027: add $a0, $zero, $s1
0028: addi $v0, $zero, 34
0029: syscall
0030: addi $s1, $zero, 1
0031: sll $s1, $s1, 2
0032: add $a0, $zero, $s1
0033: addi $v0, $zero, 34
0034: syscall
0035: beq $s1, $zero, 1
0036: j 0x0000307C
0037: addi $s1, $zero, 1
0038: sll $s1, $s1, 31
0039: add $a0, $zero, $s1
0040: addi $v0, $zero, 34
0041: syscall
0042: Unknown R-type funct: 0x3
0043: add $a0, $zero, $s1
0044: addi $v0, $zero, 34
0045: syscall
0046: Unknown R-type funct: 0x3
0047: add $a0, $zero, $s1
0048: addi $v0, $zero, 34
0049: syscall
0050: Unknown R-type funct: 0x3
0051: add $a0, $zero, $s1
0052: addi $v0, $zero, 34
0053: syscall
0054: Unknown R-type funct: 0x3
0055: add $a0, $zero, $s1
0056: addi $v0, $zero, 34
0057: syscall
0058: Unknown R-type funct: 0x3
0059: add $a0, $zero, $s1
0060: addi $v0, $zero, 34
0061: syscall
0062: Unknown R-type funct: 0x3
0063: add $a0, $zero, $s1
0064: addi $v0, $zero, 34
0065: syscall
0066: Unknown R-type funct: 0x3
0067: add $a0, $zero, $s1
0068: addi $v0, $zero, 34
0069: syscall
0070: Unknown R-type funct: 0x3
0071: add $a0, $zero, $s1
0072: addi $v0, $zero, 34
0073: syscall
0074: addi $s0, $zero, 1
0075: sll $s3, $s0, 31
0076: Unknown R-type funct: 0x3
0077: Unknown R-type funct: 0x21
0078: addi $s2, $zero, 12
0079: Unknown opcode: 0x9
0080: Unknown opcode: 0x9
0081: andi $s0, $s0, 0xF
0082: addi $t0, $zero, 8
0083: addi $t1, $zero, 1
0084: sll $s3, $s3, 4
0085: or $s3, $s3, $s0
0086: add $a0, $zero, $s3
0087: addi $v0, $zero, 34
0088: syscall
0089: sub $t0, $t0, $t1
0090: bne $t0, $zero, -7
0091: addi $s0, $s0, 1
0092: addi $t8, $zero, 15
0093: and $s0, $s0, $t8
0094: sll $s0, $s0, 28
0095: addi $t0, $zero, 8
0096: addi $t1, $zero, 1
0097: srl $s3, $s3, 4
0098: or $s3, $s3, $s0
0099: Unknown R-type funct: 0x21
0100: addi $v0, $zero, 34
0101: syscall
0102: sub $t0, $t0, $t1
0103: bne $t0, $zero, -7
0104: srl $s0, $s0, 28
0105: sub $s6, $s6, $t1
0106: beq $s6, $zero, 1
0107: j 0x00003140
0108: add $t0, $zero, $zero
0109: Unknown R-type funct: 0x27
0110: sll $t0, $t0, 16
0111: ori $t0, $t0, 0xFFFF
0112: Unknown R-type funct: 0x21
0113: addi $v0, $zero, 34
0114: syscall
0115: addi $s1, $zero, 4
0116: sw $s1, 0($s1)
0117: lw $s2, 0($s1)
0118: addi $s2, $s2, -4
0119: addi $s0, $zero, 0
0120: addi $s1, $s0, 1
0121: add $s0, $s0, $s1
0122: addi $s2, $s2, 4
0123: sw $s0, 0($s2)
0124: addi $s1, $s1, 1
0125: add $s0, $s0, $s1
0126: addi $s2, $s2, 4
0127: sw $s0, 0($s2)
0128: addi $s1, $s1, 1
0129: add $s0, $s0, $s1
0130: addi $s2, $s2, 4
0131: sw $s0, 0($s2)
0132: addi $s1, $s1, 1
0133: add $s0, $s0, $s1
0134: addi $s2, $s2, 4
0135: sw $s0, 0($s2)
0136: addi $s1, $s1, 1
0137: add $s0, $s0, $s1
0138: addi $s2, $s2, 4
0139: sw $s0, 0($s2)
0140: addi $s1, $s1, 1
0141: add $s0, $s0, $s1
0142: addi $s2, $s2, 4
0143: sw $s0, 0($s2)
0144: addi $s1, $s1, 1
0145: add $s0, $s0, $s1
0146: addi $s2, $s2, 4
0147: sw $s0, 0($s2)
0148: addi $t1, $zero, 1
0149: lw $t0, 4($zero)
0150: bne $t0, $t1, 143
0151: sw $zero, 4($zero)
0152: addi $t1, $zero, 3
0153: lw $t0, 8($zero)
0154: bne $t0, $t1, 139
0155: sw $zero, 8($zero)
0156: addi $t1, $zero, 6
0157: lw $t0, 12($zero)
0158: bne $t0, $t1, 135
0159: sw $zero, 12($zero)
0160: addi $t1, $zero, 10
0161: lw $t0, 16($zero)
0162: bne $t0, $t1, 131
0163: sw $zero, 16($zero)
0164: addi $t1, $zero, 15
0165: lw $t0, 20($zero)
0166: bne $t0, $t1, 127
0167: sw $zero, 20($zero)
0168: addi $t1, $zero, 21
0169: lw $t0, 24($zero)
0170: bne $t0, $t1, 123
0171: sw $zero, 24($zero)
0172: addi $t1, $zero, 28
0173: lw $t0, 28($zero)
0174: bne $t0, $t1, 119
0175: sw $zero, 28($zero)
0176: addi $s0, $zero, -1
0177: addi $s1, $zero, 0
0178: sw $s0, 0($s1)
0179: addi $s0, $s0, 1
0180: addi $s1, $s1, 4
0181: sw $s0, 0($s1)
0182: addi $s0, $s0, 1
0183: addi $s1, $s1, 4
0184: sw $s0, 0($s1)
0185: addi $s0, $s0, 1
0186: addi $s1, $s1, 4
0187: sw $s0, 0($s1)
0188: addi $s0, $s0, 1
0189: addi $s1, $s1, 4
0190: sw $s0, 0($s1)
0191: addi $s0, $s0, 1
0192: addi $s1, $s1, 4
0193: sw $s0, 0($s1)
0194: addi $s0, $s0, 1
0195: addi $s1, $s1, 4
0196: sw $s0, 0($s1)
0197: addi $s0, $s0, 1
0198: addi $s1, $s1, 4
0199: sw $s0, 0($s1)
0200: addi $s0, $s0, 1
0201: addi $s1, $s1, 4
0202: sw $s0, 0($s1)
0203: addi $s0, $s0, 1
0204: addi $s1, $s1, 4
0205: sw $s0, 0($s1)
0206: addi $s0, $s0, 1
0207: addi $s1, $s1, 4
0208: sw $s0, 0($s1)
0209: addi $s0, $s0, 1
0210: addi $s1, $s1, 4
0211: sw $s0, 0($s1)
0212: addi $s0, $s0, 1
0213: addi $s1, $s1, 4
0214: sw $s0, 0($s1)
0215: addi $s0, $s0, 1
0216: addi $s1, $s1, 4
0217: sw $s0, 0($s1)
0218: addi $s0, $s0, 1
0219: addi $s1, $s1, 4
0220: sw $s0, 0($s1)
0221: addi $s0, $s0, 1
0222: addi $s1, $s1, 4
0223: sw $s0, 0($s1)
0224: addi $s0, $s0, 1
0225: addi $s1, $s1, 4
0226: addi $s0, $s0, 1
0227: add $s0, $zero, $zero
0228: addi $s1, $zero, 60
0229: lw $s3, 0($s0)
0230: lw $s4, 0($s1)
0231: slt $t0, $s3, $s4
0232: beq $t0, $zero, 2
0233: sw $s3, 0($s1)
0234: sw $s4, 0($s0)
0235: addi $s1, $s1, -4
0236: bne $s0, $s1, -8
0237: add $a0, $zero, $s0
0238: addi $v0, $zero, 34
0239: syscall
0240: addi $s0, $s0, 4
0241: addi $s1, $zero, 60
0242: bne $s0, $s1, -14
0243: addi $s0, $zero, 1
0244: addi $s2, $zero, 255
0245: addi $s1, $zero, 1
0246: addi $s3, $zero, 3
0247: beq $s0, $s2, 5
0248: beq $s0, $s0, 4
0249: addi $s1, $zero, 1
0250: addi $s2, $zero, 2
0251: addi $s3, $zero, 3
0252: j 0x00003498
0253: add $a0, $zero, $s0
0254: addi $v0, $zero, 1
0255: syscall
0256: bne $s1, $s1, 5
0257: bne $s1, $s2, 4
0258: addi $s1, $zero, 1
0259: addi $s2, $zero, 2
0260: addi $s3, $zero, 3
0261: j 0x00003498
0262: add $a0, $zero, $s3
0263: addi $v0, $zero, 1
0264: syscall
0265: addi $s1, $zero, -1
0266: sll $s1, $s1, 16
0267: add $a0, $zero, $zero
0268: Unknown opcode: 0x9
0269: Unknown opcode: 0x9
0270: bne $a0, $zero, 23
0271: add $a0, $zero, $zero
0272: Unknown opcode: 0x9
0273: Unknown opcode: 0x9
0274: bne $a0, $zero, 19
0275: add $a0, $zero, $zero
0276: ori $a0, $a0, 0x7FFF
0277: and $a0, $a0, $s1
0278: bne $a0, $zero, 15
0279: add $a0, $zero, $zero
0280: ori $a0, $a0, 0x8000
0281: and $a0, $a0, $s1
0282: bne $a0, $zero, 11
0283: Unknown opcode: 0x9
0284: j 0x00003480
0285: j 0x00003498
0286: addi $v0, $zero, 10
0287: syscall
0288: addi $a0, $zero, 7405
0289: sll $a0, $a0, 16
0290: ori $a0, $a0, 0xCAFE
0291: addi $v0, $zero, 34
0292: syscall
0293: j 0x00003478
0294: Unknown opcode: 0xF
0295: ori $at, $at, 0xBAAD
0296: add $a0, $zero, $at
0297: sll $a0, $a0, 16
0298: ori $a0, $a0, 0xC0DE
0299: addi $v0, $zero, 34
0300: syscall
0301: j 0x00003478
0302: addi $s0, $zero, 0
0303: addi $s0, $s0, 1
0304: add $a0, $zero, $s0
0305: addi $v0, $zero, 34
0306: syscall
0307: addi $s0, $s0, 2
0308: add $a0, $zero, $s0
0309: addi $v0, $zero, 34
0310: syscall
0311: addi $s0, $s0, 3
0312: add $a0, $zero, $s0
0313: addi $v0, $zero, 34
0314: syscall
0315: addi $s0, $s0, 4
0316: add $a0, $zero, $s0
0317: addi $v0, $zero, 34
0318: syscall
0319: addi $s0, $s0, 5
0320: add $a0, $zero, $s0
0321: addi $v0, $zero, 34
0322: syscall
0323: addi $s0, $s0, 6
0324: add $a0, $zero, $s0
0325: addi $v0, $zero, 34
0326: syscall
0327: addi $s0, $s0, 7
0328: add $a0, $zero, $s0
0329: addi $v0, $zero, 34
0330: syscall
0331: addi $s0, $s0, 8
0332: add $a0, $zero, $s0
0333: addi $v0, $zero, 34
0334: syscall
0335: jr $ra
0336: sll $zero, $zero, 0
0337: sll $zero, $zero, 0
0338: sll $zero, $zero, 0
0339: sll $zero, $zero, 0
0340: sll $zero, $zero, 0
0341: sll $zero, $zero, 0
0342: sll $zero, $zero, 0
0343: sll $zero, $zero, 0
0344: sll $zero, $zero, 0
0345: sll $zero, $zero, 0
0346: sll $zero, $zero, 0
0347: sll $zero, $zero, 0
0348: sll $zero, $zero, 0
0349: sll $zero, $zero, 0
0350: sll $zero, $zero, 0
0351: sll $zero, $zero, 0
0352: sll $zero, $zero, 0
0353: sll $zero, $zero, 0
0354: sll $zero, $zero, 0
0355: sll $zero, $zero, 0
0356: sll $zero, $zero, 0
0357: sll $zero, $zero, 0
0358: sll $zero, $zero, 0
0359: sll $zero, $zero, 0
0360: sll $zero, $zero, 0
0361: sll $zero, $zero, 0
0362: sll $zero, $zero, 0
0363: sll $zero, $zero, 0
0364: sll $zero, $zero, 0
0365: sll $zero, $zero, 0
0366: sll $zero, $zero, 0
0367: sll $zero, $zero, 0
0368: sll $zero, $zero, 0
0369: sll $zero, $zero, 0
0370: sll $zero, $zero, 0
0371: sll $zero, $zero, 0
0372: sll $zero, $zero, 0
0373: sll $zero, $zero, 0
0374: sll $zero, $zero, 0
0375: sll $zero, $zero, 0
0376: sll $zero, $zero, 0
0377: sll $zero, $zero, 0
0378: sll $zero, $zero, 0
0379: sll $zero, $zero, 0
0380: sll $zero, $zero, 0
0381: sll $zero, $zero, 0
0382: sll $zero, $zero, 0
0383: sll $zero, $zero, 0
0384: sll $zero, $zero, 0
0385: sll $zero, $zero, 0
0386: sll $zero, $zero, 0
0387: sll $zero, $zero, 0
0388: sll $zero, $zero, 0
0389: sll $zero, $zero, 0
0390: sll $zero, $zero, 0
0391: sll $zero, $zero, 0
0392: sll $zero, $zero, 0
0393: sll $zero, $zero, 0
0394: sll $zero, $zero, 0
0395: sll $zero, $zero, 0
0396: sll $zero, $zero, 0
0397: sll $zero, $zero, 0
0398: sll $zero, $zero, 0
0399: sll $zero, $zero, 0
0400: sll $zero, $zero, 0
0401: sll $zero, $zero, 0
0402: sll $zero, $zero, 0
0403: sll $zero, $zero, 0
0404: sll $zero, $zero, 0
0405: sll $zero, $zero, 0
0406: sll $zero, $zero, 0
0407: sll $zero, $zero, 0
0408: sll $zero, $zero, 0
0409: sll $zero, $zero, 0
0410: sll $zero, $zero, 0
0411: sll $zero, $zero, 0
0412: sll $zero, $zero, 0
0413: sll $zero, $zero, 0
0414: sll $zero, $zero, 0
0415: sll $zero, $zero, 0
0416: sll $zero, $zero, 0
0417: sll $zero, $zero, 0
0418: sll $zero, $zero, 0
0419: sll $zero, $zero, 0
0420: sll $zero, $zero, 0
0421: sll $zero, $zero, 0
0422: sll $zero, $zero, 0
0423: sll $zero, $zero, 0
0424: sll $zero, $zero, 0
0425: sll $zero, $zero, 0
0426: sll $zero, $zero, 0
0427: sll $zero, $zero, 0
0428: sll $zero, $zero, 0
0429: sll $zero, $zero, 0
0430: sll $zero, $zero, 0
0431: sll $zero, $zero, 0
0432: sll $zero, $zero, 0
0433: sll $zero, $zero, 0
0434: sll $zero, $zero, 0
0435: sll $zero, $zero, 0
0436: sll $zero, $zero, 0
0437: sll $zero, $zero, 0
0438: sll $zero, $zero, 0
0439: sll $zero, $zero, 0
0440: sll $zero, $zero, 0
0441: sll $zero, $zero, 0
0442: sll $zero, $zero, 0
0443: sll $zero, $zero, 0
0444: sll $zero, $zero, 0
0445: sll $zero, $zero, 0
0446: sll $zero, $zero, 0
0447: sll $zero, $zero, 0
0448: sll $zero, $zero, 0
0449: sll $zero, $zero, 0
0450: sll $zero, $zero, 0
0451: sll $zero, $zero, 0
0452: sll $zero, $zero, 0
0453: sll $zero, $zero, 0
0454: sll $zero, $zero, 0
0455: sll $zero, $zero, 0
0456: sll $zero, $zero, 0
0457: sll $zero, $zero, 0
0458: sll $zero, $zero, 0
0459: sll $zero, $zero, 0
0460: sll $zero, $zero, 0
0461: sll $zero, $zero, 0
0462: sll $zero, $zero, 0
0463: sll $zero, $zero, 0
0464: sll $zero, $zero, 0
0465: sll $zero, $zero, 0
0466: sll $zero, $zero, 0
0467: sll $zero, $zero, 0
0468: sll $zero, $zero, 0
0469: sll $zero, $zero, 0
0470: sll $zero, $zero, 0
0471: sll $zero, $zero, 0
0472: sll $zero, $zero, 0
0473: sll $zero, $zero, 0
0474: sll $zero, $zero, 0
0475: sll $zero, $zero, 0
0476: sll $zero, $zero, 0
0477: sll $zero, $zero, 0
0478: sll $zero, $zero, 0
0479: sll $zero, $zero, 0
0480: sll $zero, $zero, 0
0481: sll $zero, $zero, 0
0482: sll $zero, $zero, 0
0483: sll $zero, $zero, 0
0484: sll $zero, $zero, 0
0485: sll $zero, $zero, 0
0486: sll $zero, $zero, 0
0487: sll $zero, $zero, 0
0488: sll $zero, $zero, 0
0489: sll $zero, $zero, 0
0490: sll $zero, $zero, 0
0491: sll $zero, $zero, 0
0492: sll $zero, $zero, 0
0493: sll $zero, $zero, 0
0494: sll $zero, $zero, 0
0495: sll $zero, $zero, 0
0496: sll $zero, $zero, 0
0497: sll $zero, $zero, 0
0498: sll $zero, $zero, 0
0499: sll $zero, $zero, 0
0500: sll $zero, $zero, 0
0501: sll $zero, $zero, 0
0502: sll $zero, $zero, 0
0503: sll $zero, $zero, 0
0504: sll $zero, $zero, 0
0505: sll $zero, $zero, 0
0506: sll $zero, $zero, 0
0507: sll $zero, $zero, 0
0508: sll $zero, $zero, 0
0509: sll $zero, $zero, 0
0510: sll $zero, $zero, 0
0511: sll $zero, $zero, 0