//
//  Data+Gzip.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 22/06/2021.
//

import struct Foundation.Data

import zlib

public struct GzipError: Swift.Error {

    public enum `Type`: Equatable {

        /// The stream structure was inconsistent.
        ///
        /// - underlying zlib error: `Z_STREAM_ERROR` (-2)
        case stream

        /// The input data was corrupted
        /// (input stream not conforming to the zlib format or incorrect check value).
        ///
        /// - underlying zlib error: `Z_DATA_ERROR` (-3)
        case data

        /// There was not enough memory.
        ///
        /// - underlying zlib error: `Z_MEM_ERROR` (-4)
        case memory

        /// No progress is possible or there was not enough room in the output buffer.
        ///
        /// - underlying zlib error: `Z_BUF_ERROR` (-5)
        case buffer

        /// The zlib library version is incompatible with the version assumed by the caller.
        ///
        /// - underlying zlib error: `Z_VERSION_ERROR` (-6)
        case version

        /// An unknown error occurred.
        ///
        /// - parameter code: return error by zlib
        case unknown(code: Int)
    }

    /// Error type.
    public let type: Type

    /// Returned message by zlib.
    public let message: String

    internal init(code: Int32, msg: UnsafePointer<CChar>?) {

        message = {
            guard let msg = msg, let message = String(validatingUTF8: msg) else {
                return "Unknown gzip error"
            }
            return message
        }()

        type = {
            switch code {
            case Z_STREAM_ERROR:
                return .stream
            case Z_DATA_ERROR:
                return .data
            case Z_MEM_ERROR:
                return .memory
            case Z_BUF_ERROR:
                return .buffer
            case Z_VERSION_ERROR:
                return .version
            default:
                return .unknown(code: Int(code))
            }
        }()
    }
}

extension Data {

    /// Whether the receiver is compressed in gzip format.
    public var isGzipped: Bool {

        return self.starts(with: [0x1f, 0x8b])
    }

    /// Create a new `Data` instance by decompressing the receiver using zlib.
    /// Throws an error if decompression failed.
    ///
    /// - Returns: Decompressed `Data` instance.
    /// - Throws: `GzipError`

    public func gunzip() throws -> Data {

        guard !self.isEmpty else {

            return Data()
        }

        var stream = z_stream()
        var status: Int32

        status = inflateInit2_(&stream, MAX_WBITS + 32, ZLIB_VERSION, Int32(DataSize.stream))

        guard status == Z_OK else {

            throw GzipError(code: status, msg: stream.msg)
        }

        var data = Data(capacity: self.count * 2)
        repeat {

            if Int(stream.total_out) >= data.count {

                data.count += self.count / 2
            }

            let inputCount = self.count
            let outputCount = data.count

            self.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in

                guard let nextInBaseAddress = inputPointer.bindMemory(to: Bytef.self).baseAddress else {
                    status = Z_STREAM_END
                    return
                }

                stream.next_in = UnsafeMutablePointer<Bytef>(mutating: nextInBaseAddress)
                    .advanced(by: Int(stream.total_in))
                stream.avail_in = uint(inputCount) - uInt(stream.total_in)

                data.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in

                    guard let nextOutBaseAddress = outputPointer.bindMemory(to: Bytef.self).baseAddress else {
                        status = Z_STREAM_END
                        return
                    }

                    stream.next_out = nextOutBaseAddress.advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(outputCount) - uInt(stream.total_out)

                    status = inflate(&stream, Z_SYNC_FLUSH)

                    stream.next_out = nil
                }

                stream.next_in = nil
            }
        } while status == Z_OK

        guard inflateEnd(&stream) == Z_OK, status == Z_STREAM_END else {

            throw GzipError(code: status, msg: stream.msg)
        }

        data.count = Int(stream.total_out)

        return data
    }
}

private enum DataSize {

    static let chunk = 1 << 14
    static let stream = MemoryLayout<z_stream>.size
}
