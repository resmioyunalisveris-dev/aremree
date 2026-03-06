#import <Foundation/Foundation.h>
#include <substrate.h>
#include <mach-o/dyld.h>
#include <vector>

// --- AYARLAR VE DEĞİŞKENLER ---
bool isMenuVisible = true;
bool isAimbot360 = false, isMagic = false, isESP = false;
bool isFlashV3 = false, isCrouchSpeed = false, isProneSpeed = false;
bool isMevlana = false, isRapidFire = false, isNoRecoil = false;
bool isNoGrass = false, isInstantHit = false;

// --- BELLEK YAZICI (PATCHER) ---
void WriteToMemory(uintptr_t offset, std::vector<uint8_t> bytes) {
    uintptr_t base = _dyld_get_image_header(0);
    if (base == 0) return;
    vm_protect(mach_task_self(), (vm_address_t)(base + offset), bytes.size(), false, VM_PROT_ALL);
    vm_write(mach_task_self(), (vm_address_t)(base + offset), (vm_offset_t)bytes.data(), bytes.size());
}

// --- ANA HİLE FONKSİYONU ---
void ApplyGodMode() {
    // 1. COMBAT (SAVAŞ & HASAR BUGU ÇÖZÜMÜ)
    if (isAimbot360) {
        WriteToMemory(0x072CE2F0, {0x20, 0x00, 0x80, 0x52, 0xC0, 0x03, 0x5F, 0xD6}); // 360 Headshot
    }
    if (isMagic) {
        WriteToMemory(0x0715D340, {0xE0, 0x03, 0x27, 0x1E}); // Magic Bullet
        WriteToMemory(0x0712A400, {0x00, 0x00, 0xA0, 0x42}); // Instant Hit (Hasar Bugu Çözümü)
    }
    if (isMevlana) {
        WriteToMemory(0x06C8A120, {0x20, 0x00, 0x80, 0x52, 0xC0, 0x03, 0x5F, 0xD6}); // Spin Bot
    }
    if (isRapidFire) {
        WriteToMemory(0x0712A450, {0x00, 0x00, 0x00, 0x00}); // No Interval
    }
    if (isNoRecoil) {
        WriteToMemory(0x06B8D120, {0x00, 0x00, 0x00, 0x00}); // Zero Shake
    }

    // 2. SPEED (HAREKET)
    if (isFlashV3) WriteToMemory(0x073014F0, {0x00, 0x00, 0x40, 0x40}); // Flash
    if (isCrouchSpeed) WriteToMemory(0x059A0C48, {0x7F, 0x7F, 0x01, 0xD5}); // Senin Özel Kodun
    if (isProneSpeed) WriteToMemory(0x059A0C48, {0x00, 0x00, 0xA0, 0x41}); // Yılan Hızı

    // 3. WORLD (DÜNYA)
    if (isNoGrass) WriteToMemory(0x06A1B2C0, {0x00, 0x00, 0x80, 0x3F}); // Çim Silme
    
    // VIP BYPASS (Her Zaman Açık)
    WriteToMemory(0x04D2E100, {0x1F, 0x20, 0x03, 0xD5});
}

// --- THEOS ENJEKSİYON ---
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Menü ve kontroller buraya gelecek (Şimdilik özellikleri direkt aktif etmek için çağırıyoruz)
        ApplyGodMode();
    });
}