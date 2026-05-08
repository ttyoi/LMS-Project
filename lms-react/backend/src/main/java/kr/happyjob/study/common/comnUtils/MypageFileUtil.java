package kr.happyjob.study.common.comnUtils;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;

public class MypageFileUtil {


    private static final String NETWORK_PATH = "\\\\192.168.0.130\\sharefolder\\";

    public static String convertPath(String physicalPath) {
        if (physicalPath.startsWith("Z:/")) {
            physicalPath = physicalPath
                    .replace("Z:/", NETWORK_PATH)
                    .replace("/", "\\");
        } else if (physicalPath.startsWith("//")) {
            physicalPath = physicalPath.replace("/", "\\");
        }
        return physicalPath;
    }


    public static void save(MultipartFile file, String physicalPath) throws Exception {
        physicalPath = convertPath(physicalPath);
        File dest = new File(physicalPath);

        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        file.transferTo(dest);
    }


    public static void delete(String physicalPath) {
        try {
            physicalPath = convertPath(physicalPath);
            File file = new File(physicalPath);
            if (file.exists()) file.delete();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static File getFile(String physicalPath) {
        physicalPath = convertPath(physicalPath);
        return new File(physicalPath);
    }
}
