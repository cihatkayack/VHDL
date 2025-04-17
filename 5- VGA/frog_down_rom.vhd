library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frog_down_rom is
    Port (
        clk         : in  std_logic;
        address     : in  std_logic_vector(9 downto 0);
        color_data  : out std_logic_vector(11 downto 0)
    );
end frog_down_rom;

architecture Behavioral of frog_down_rom is
    type rom_type is array (0 to 783) of std_logic_vector(11 downto 0);
    signal rom : rom_type := (
        0 => "111111111111",
        1 => "111111111111",
        2 => "111111111111",
        3 => "111111111111",
        4 => "000111110000",
        5 => "111111111111",
        6 => "111111111111",
        7 => "111111111111",
        8 => "111111111111",
        9 => "111111111111",
        10 => "111111111111",
        11 => "111111111111",
        12 => "111111111111",
        13 => "111111111111",
        14 => "111111111111",
        15 => "111111111111",
        16 => "111111111111",
        17 => "111111111111",
        18 => "111111111111",
        19 => "111111111111",
        20 => "111111111111",
        21 => "111111111111",
        22 => "111111111111",
        23 => "000111110000",
        24 => "111111111111",
        25 => "111111111111",
        26 => "111111111111",
        27 => "111111111111",
        28 => "111111111111",
        29 => "111111111111",
        30 => "111111111111",
        31 => "000111110000",
        32 => "000111110000",
        33 => "000111110000",
        34 => "111111111111",
        35 => "111111111111",
        36 => "111111111111",
        37 => "111111111111",
        38 => "111111111111",
        39 => "111111111111",
        40 => "111111111111",
        41 => "111111111111",
        42 => "111111111111",
        43 => "111111111111",
        44 => "111111111111",
        45 => "111111111111",
        46 => "111111111111",
        47 => "111111111111",
        48 => "111111111111",
        49 => "111111111111",
        50 => "000111110000",
        51 => "000111110000",
        52 => "000111110000",
        53 => "111111111111",
        54 => "111111111111",
        55 => "111111111111",
        56 => "111111111111",
        57 => "111111111111",
        58 => "111111111111",
        59 => "000111110000",
        60 => "000111110000",
        61 => "000111110000",
        62 => "111111111111",
        63 => "111111111111",
        64 => "111111111111",
        65 => "111111111111",
        66 => "111111111111",
        67 => "111111111111",
        68 => "111111111111",
        69 => "111111111111",
        70 => "111111111111",
        71 => "111111111111",
        72 => "111111111111",
        73 => "111111111111",
        74 => "111111111111",
        75 => "111111111111",
        76 => "111111111111",
        77 => "111111111111",
        78 => "000111110000",
        79 => "000111110000",
        80 => "000111110000",
        81 => "111111111111",
        82 => "111111111111",
        83 => "111111111111",
        84 => "111111111111",
        85 => "111111111111",
        86 => "111111111111",
        87 => "000111110000",
        88 => "000111110000",
        89 => "000111110000",
        90 => "111111111111",
        91 => "111111111111",
        92 => "111111111111",
        93 => "111111111111",
        94 => "111111111111",
        95 => "111111111111",
        96 => "111111111111",
        97 => "111111111111",
        98 => "111111111111",
        99 => "111111111111",
        100 => "111111111111",
        101 => "111111111111",
        102 => "111111111111",
        103 => "111111111111",
        104 => "111111111111",
        105 => "111111111111",
        106 => "000111110000",
        107 => "000111110000",
        108 => "000111110000",
        109 => "111111111111",
        110 => "111111111111",
        111 => "111111111111",
        112 => "111111111111",
        113 => "000111110000",
        114 => "000111110000",
        115 => "000111110000",
        116 => "000111110000",
        117 => "000111110000",
        118 => "111111111111",
        119 => "111111111111",
        120 => "111111111111",
        121 => "111111111111",
        122 => "111111111111",
        123 => "000111110000",
        124 => "111111110000",
        125 => "111111110000",
        126 => "111111110000",
        127 => "111111110000",
        128 => "000111110000",
        129 => "111111111111",
        130 => "111111111111",
        131 => "111111111111",
        132 => "111111111111",
        133 => "111111111111",
        134 => "000111110000",
        135 => "000111110000",
        136 => "000111110000",
        137 => "000111110000",
        138 => "000111110000",
        139 => "111111111111",
        140 => "000111110000",
        141 => "000111110000",
        142 => "000111110000",
        143 => "000111110000",
        144 => "000111110000",
        145 => "000111110000",
        146 => "111111111111",
        147 => "111111111111",
        148 => "111111111111",
        149 => "111111111111",
        150 => "000111110000",
        151 => "000111110000",
        152 => "111111110000",
        153 => "111111110000",
        154 => "111111110000",
        155 => "111111110000",
        156 => "000111110000",
        157 => "000111110000",
        158 => "111111111111",
        159 => "111111111111",
        160 => "111111111111",
        161 => "111111111111",
        162 => "000111110000",
        163 => "000111110000",
        164 => "000111110000",
        165 => "000111110000",
        166 => "000111110000",
        167 => "000111110000",
        168 => "000111110000",
        169 => "000111110000",
        170 => "000111110000",
        171 => "000111110000",
        172 => "000111110000",
        173 => "000111110000",
        174 => "111111111111",
        175 => "111111111111",
        176 => "111111111111",
        177 => "000111110000",
        178 => "000111110000",
        179 => "111111110000",
        180 => "111111110000",
        181 => "111111110000",
        182 => "111111110000",
        183 => "111111110000",
        184 => "111111110000",
        185 => "000111110000",
        186 => "000111110000",
        187 => "111111111111",
        188 => "111111111111",
        189 => "111111111111",
        190 => "000111110000",
        191 => "000111110000",
        192 => "000111110000",
        193 => "000111110000",
        194 => "000111110000",
        195 => "000111110000",
        196 => "111111111111",
        197 => "000111110000",
        198 => "000111110000",
        199 => "000111110000",
        200 => "000111110000",
        201 => "000111110000",
        202 => "111111111111",
        203 => "111111111111",
        204 => "000111110000",
        205 => "000111110000",
        206 => "111111110000",
        207 => "111111110000",
        208 => "111111110000",
        209 => "111111110000",
        210 => "111111110000",
        211 => "111111110000",
        212 => "111111110000",
        213 => "111111110000",
        214 => "000111110000",
        215 => "000111110000",
        216 => "111111111111",
        217 => "111111111111",
        218 => "000111110000",
        219 => "000111110000",
        220 => "000111110000",
        221 => "000111110000",
        222 => "000111110000",
        223 => "111111111111",
        224 => "111111111111",
        225 => "111111111111",
        226 => "111111111111",
        227 => "000111110000",
        228 => "000111110000",
        229 => "000111110000",
        230 => "111111111111",
        231 => "111111111111",
        232 => "111111110000",
        233 => "111111110000",
        234 => "111111110000",
        235 => "111111110000",
        236 => "111111110000",
        237 => "111111110000",
        238 => "111111110000",
        239 => "000111110000",
        240 => "000111110000",
        241 => "111111110000",
        242 => "111111110000",
        243 => "000111110000",
        244 => "111111111111",
        245 => "111111111111",
        246 => "000111110000",
        247 => "000111110000",
        248 => "000111110000",
        249 => "111111111111",
        250 => "111111111111",
        251 => "111111111111",
        252 => "111111111111",
        253 => "111111111111",
        254 => "111111111111",
        255 => "000111110000",
        256 => "000111110000",
        257 => "000111110000",
        258 => "000111110000",
        259 => "000111110000",
        260 => "111111110000",
        261 => "111111110000",
        262 => "111111110000",
        263 => "111111110000",
        264 => "111111110000",
        265 => "111111110000",
        266 => "000111110000",
        267 => "000111110000",
        268 => "000111110000",
        269 => "000111110000",
        270 => "111111110000",
        271 => "111111110000",
        272 => "000111110000",
        273 => "000111110000",
        274 => "000111110000",
        275 => "000111110000",
        276 => "000111110000",
        277 => "111111111111",
        278 => "111111111111",
        279 => "111111111111",
        280 => "111111111111",
        281 => "111111111111",
        282 => "111111111111",
        283 => "000111110000",
        284 => "000111110000",
        285 => "000111110000",
        286 => "000111110000",
        287 => "000111110000",
        288 => "111111110000",
        289 => "111111110000",
        290 => "111111110000",
        291 => "111111110000",
        292 => "111111110000",
        293 => "000111110000",
        294 => "000111110000",
        295 => "111111110000",
        296 => "111111110000",
        297 => "000111110000",
        298 => "000111110000",
        299 => "111111110000",
        300 => "000111110000",
        301 => "000111110000",
        302 => "000111110000",
        303 => "000111110000",
        304 => "000111110000",
        305 => "111111111111",
        306 => "111111111111",
        307 => "111111111111",
        308 => "111111111111",
        309 => "111111111111",
        310 => "111111111111",
        311 => "111111111111",
        312 => "000111110000",
        313 => "000111110000",
        314 => "000111110000",
        315 => "000111110000",
        316 => "111111110000",
        317 => "000111110000",
        318 => "000111110000",
        319 => "111111110000",
        320 => "111111110000",
        321 => "000111110000",
        322 => "000111110000",
        323 => "111111110000",
        324 => "111111110000",
        325 => "000111110000",
        326 => "000111110000",
        327 => "111111110000",
        328 => "000111110000",
        329 => "000111110000",
        330 => "000111110000",
        331 => "000111110000",
        332 => "111111111111",
        333 => "111111111111",
        334 => "111111111111",
        335 => "111111111111",
        336 => "111111111111",
        337 => "111111111111",
        338 => "111111111111",
        339 => "111111111111",
        340 => "111111111111",
        341 => "111111111111",
        342 => "111111111111",
        343 => "111111111111",
        344 => "111111110000",
        345 => "111111110000",
        346 => "000111110000",
        347 => "111111110000",
        348 => "111111110000",
        349 => "111111110000",
        350 => "000111110000",
        351 => "000111110000",
        352 => "000111110000",
        353 => "000111110000",
        354 => "111111110000",
        355 => "111111110000",
        356 => "111111111111",
        357 => "111111111111",
        358 => "111111111111",
        359 => "111111111111",
        360 => "111111111111",
        361 => "111111111111",
        362 => "111111111111",
        363 => "111111111111",
        364 => "111111111111",
        365 => "111111111111",
        366 => "111111111111",
        367 => "111111111111",
        368 => "111111111111",
        369 => "111111111111",
        370 => "111111111111",
        371 => "111111111111",
        372 => "111111110000",
        373 => "111111110000",
        374 => "111111110000",
        375 => "000111110000",
        376 => "111111110000",
        377 => "111111110000",
        378 => "111111110000",
        379 => "000111110000",
        380 => "000111110000",
        381 => "111111110000",
        382 => "111111110000",
        383 => "111111110000",
        384 => "111111111111",
        385 => "111111111111",
        386 => "111111111111",
        387 => "111111111111",
        388 => "111111111111",
        389 => "111111111111",
        390 => "111111111111",
        391 => "111111111111",
        392 => "111111111111",
        393 => "111111111111",
        394 => "111111111111",
        395 => "111111111111",
        396 => "111111111111",
        397 => "111111111111",
        398 => "111111111111",
        399 => "111111111111",
        400 => "111111110000",
        401 => "111111110000",
        402 => "111111110000",
        403 => "111111110000",
        404 => "111111110000",
        405 => "111111110000",
        406 => "111111110000",
        407 => "000111110000",
        408 => "000111110000",
        409 => "111111110000",
        410 => "111111110000",
        411 => "111111110000",
        412 => "111111111111",
        413 => "111111111111",
        414 => "111111111111",
        415 => "111111111111",
        416 => "111111111111",
        417 => "111111111111",
        418 => "111111111111",
        419 => "111111111111",
        420 => "111111111111",
        421 => "111111111111",
        422 => "111111111111",
        423 => "111111111111",
        424 => "111111111111",
        425 => "111111111111",
        426 => "111111111111",
        427 => "111111111111",
        428 => "111111110000",
        429 => "111111110000",
        430 => "111111110000",
        431 => "111111110000",
        432 => "111111110000",
        433 => "111111110000",
        434 => "111111110000",
        435 => "000111110000",
        436 => "000111110000",
        437 => "111111110000",
        438 => "111111110000",
        439 => "111111110000",
        440 => "111111111111",
        441 => "111111111111",
        442 => "111111111111",
        443 => "111111111111",
        444 => "111111111111",
        445 => "111111111111",
        446 => "111111111111",
        447 => "111111111111",
        448 => "111111111111",
        449 => "111111111111",
        450 => "111111111111",
        451 => "111111111111",
        452 => "000111110000",
        453 => "000111110000",
        454 => "000111110000",
        455 => "000111110000",
        456 => "111111110000",
        457 => "111111110000",
        458 => "111111110000",
        459 => "000111110000",
        460 => "000111110000",
        461 => "111111110000",
        462 => "111111110000",
        463 => "111111110000",
        464 => "111111110000",
        465 => "111111110000",
        466 => "111111110000",
        467 => "111111110000",
        468 => "000111110000",
        469 => "000111110000",
        470 => "000111110000",
        471 => "000111110000",
        472 => "111111111111",
        473 => "111111111111",
        474 => "111111111111",
        475 => "111111111111",
        476 => "111111111111",
        477 => "111111111111",
        478 => "111111111111",
        479 => "000111110000",
        480 => "000111110000",
        481 => "000111110000",
        482 => "000111110000",
        483 => "000111110000",
        484 => "111111110000",
        485 => "111111110000",
        486 => "000111110000",
        487 => "000111110000",
        488 => "111111110000",
        489 => "111111110000",
        490 => "111111110000",
        491 => "111111110000",
        492 => "111111110000",
        493 => "111111110000",
        494 => "000111110000",
        495 => "111111110000",
        496 => "000111110000",
        497 => "000111110000",
        498 => "000111110000",
        499 => "000111110000",
        500 => "000111110000",
        501 => "111111111111",
        502 => "111111111111",
        503 => "111111111111",
        504 => "111111111111",
        505 => "111111111111",
        506 => "111111111111",
        507 => "000111110000",
        508 => "000111110000",
        509 => "000111110000",
        510 => "000111110000",
        511 => "000111110000",
        512 => "111111110000",
        513 => "000111110000",
        514 => "000111110000",
        515 => "111111110000",
        516 => "111111110000",
        517 => "111111110000",
        518 => "111111110000",
        519 => "111111110000",
        520 => "000111110000",
        521 => "000111110000",
        522 => "111111110000",
        523 => "111111110000",
        524 => "000111110000",
        525 => "000111110000",
        526 => "000111110000",
        527 => "000111110000",
        528 => "000111110000",
        529 => "111111111111",
        530 => "111111111111",
        531 => "111111111111",
        532 => "111111111111",
        533 => "111111111111",
        534 => "111111111111",
        535 => "000111110000",
        536 => "000111110000",
        537 => "000111110000",
        538 => "111111111111",
        539 => "111111111111",
        540 => "111111110000",
        541 => "111111110000",
        542 => "111111110000",
        543 => "111111110000",
        544 => "111111110000",
        545 => "111111110000",
        546 => "111111110000",
        547 => "000111110000",
        548 => "111111110000",
        549 => "111111110000",
        550 => "111111110000",
        551 => "111111110000",
        552 => "111111111111",
        553 => "111111111111",
        554 => "000111110000",
        555 => "000111110000",
        556 => "000111110000",
        557 => "111111111111",
        558 => "111111111111",
        559 => "111111111111",
        560 => "111111111111",
        561 => "000111110000",
        562 => "000111110000",
        563 => "000111110000",
        564 => "000111110000",
        565 => "000111110000",
        566 => "111111111111",
        567 => "111111111111",
        568 => "111111110000",
        569 => "111111110000",
        570 => "111111110000",
        571 => "111111110000",
        572 => "111111110000",
        573 => "111111110000",
        574 => "111111110000",
        575 => "111111110000",
        576 => "111111110000",
        577 => "111111110000",
        578 => "111111110000",
        579 => "111111110000",
        580 => "111111111111",
        581 => "111111111111",
        582 => "000111110000",
        583 => "000111110000",
        584 => "000111110000",
        585 => "000111110000",
        586 => "000111110000",
        587 => "111111111111",
        588 => "000111110000",
        589 => "000111110000",
        590 => "000111110000",
        591 => "000111110000",
        592 => "000111110000",
        593 => "000111110000",
        594 => "111111111111",
        595 => "111111111111",
        596 => "000111110000",
        597 => "000111110000",
        598 => "000111110000",
        599 => "000111110000",
        600 => "111111110000",
        601 => "111111110000",
        602 => "111111110000",
        603 => "111111110000",
        604 => "000111110000",
        605 => "000111110000",
        606 => "000111110000",
        607 => "000111110000",
        608 => "111111111111",
        609 => "111111111111",
        610 => "000111110000",
        611 => "000111110000",
        612 => "000111110000",
        613 => "000111110000",
        614 => "000111110000",
        615 => "000111110000",
        616 => "000111110000",
        617 => "000111110000",
        618 => "000111110000",
        619 => "000111110000",
        620 => "000111110000",
        621 => "000111110000",
        622 => "111111111111",
        623 => "111111111111",
        624 => "000111110000",
        625 => "000111110000",
        626 => "000111110000",
        627 => "000111110000",
        628 => "000111110000",
        629 => "111111110000",
        630 => "111111110000",
        631 => "000111110000",
        632 => "000111110000",
        633 => "000111110000",
        634 => "000111110000",
        635 => "000111110000",
        636 => "111111111111",
        637 => "111111111111",
        638 => "000111110000",
        639 => "000111110000",
        640 => "000111110000",
        641 => "000111110000",
        642 => "000111110000",
        643 => "000111110000",
        644 => "111111111111",
        645 => "000111110000",
        646 => "000111110000",
        647 => "000111110000",
        648 => "000111110000",
        649 => "000111110000",
        650 => "111111111111",
        651 => "111111111111",
        652 => "111000001101",
        653 => "111000001101",
        654 => "111000001101",
        655 => "000111110000",
        656 => "000111110000",
        657 => "111111110000",
        658 => "111111110000",
        659 => "000111110000",
        660 => "000111110000",
        661 => "111000001101",
        662 => "111000001101",
        663 => "111000001101",
        664 => "111111111111",
        665 => "111111111111",
        666 => "000111110000",
        667 => "000111110000",
        668 => "000111110000",
        669 => "000111110000",
        670 => "000111110000",
        671 => "111111111111",
        672 => "111111111111",
        673 => "111111111111",
        674 => "111111111111",
        675 => "000111110000",
        676 => "000111110000",
        677 => "000111110000",
        678 => "111111111111",
        679 => "111111111111",
        680 => "111000001101",
        681 => "111000001101",
        682 => "111000001101",
        683 => "000111110000",
        684 => "000111110000",
        685 => "111111110000",
        686 => "111111110000",
        687 => "000111110000",
        688 => "000111110000",
        689 => "111000001101",
        690 => "111000001101",
        691 => "111000001101",
        692 => "111111111111",
        693 => "111111111111",
        694 => "000111110000",
        695 => "000111110000",
        696 => "000111110000",
        697 => "111111111111",
        698 => "111111111111",
        699 => "111111111111",
        700 => "111111111111",
        701 => "111111111111",
        702 => "111111111111",
        703 => "000111110000",
        704 => "000111110000",
        705 => "000111110000",
        706 => "111111111111",
        707 => "111111111111",
        708 => "111111111111",
        709 => "111000001101",
        710 => "111000001101",
        711 => "000111110000",
        712 => "000111110000",
        713 => "111111110000",
        714 => "111111110000",
        715 => "000111110000",
        716 => "000111110000",
        717 => "111000001101",
        718 => "111000001101",
        719 => "111111111111",
        720 => "111111111111",
        721 => "111111111111",
        722 => "000111110000",
        723 => "000111110000",
        724 => "000111110000",
        725 => "111111111111",
        726 => "111111111111",
        727 => "111111111111",
        728 => "111111111111",
        729 => "111111111111",
        730 => "111111111111",
        731 => "000111110000",
        732 => "000111110000",
        733 => "000111110000",
        734 => "111111111111",
        735 => "111111111111",
        736 => "111111111111",
        737 => "111111111111",
        738 => "111111111111",
        739 => "111111110000",
        740 => "111111110000",
        741 => "111111110000",
        742 => "111111110000",
        743 => "111111110000",
        744 => "111111110000",
        745 => "111111111111",
        746 => "111111111111",
        747 => "111111111111",
        748 => "111111111111",
        749 => "111111111111",
        750 => "000111110000",
        751 => "000111110000",
        752 => "000111110000",
        753 => "111111111111",
        754 => "111111111111",
        755 => "111111111111",
        756 => "111111111111",
        757 => "111111111111",
        758 => "111111111111",
        759 => "111111111111",
        760 => "000111110000",
        761 => "111111111111",
        762 => "111111111111",
        763 => "111111111111",
        764 => "111111111111",
        765 => "111111111111",
        766 => "111111111111",
        767 => "111111111111",
        768 => "111111110000",
        769 => "000111110000",
        770 => "000111110000",
        771 => "111111110000",
        772 => "111111110000",
        773 => "111111111111",
        774 => "111111111111",
        775 => "111111111111",
        776 => "111111111111",
        777 => "111111111111",
        778 => "111111111111",
        779 => "000111110000",
        780 => "111111111111",
        781 => "111111111111",
        782 => "111111111111",
        783 => "111111111111"
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            color_data <= rom(to_integer(unsigned(address)));
        end if;
    end process;
end Behavioral;
